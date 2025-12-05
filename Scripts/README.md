# スナップショットカタログスクリプト

このディレクトリには、スナップショットテストの画像からHugo用のUIカタログを自動生成するスクリプトが含まれています。

## 📄 ファイル一覧

| ファイル | 説明 |
|---------|------|
| `prepare_snapshot_catalog.py` | メインスクリプト：スナップショットPNGをコピーし、メタデータJSONを生成 |
| `test_metadata_extraction.py` | テストスクリプト：メタデータ抽出機能の動作確認 |

## 🚀 使い方

### 基本的な使用方法

```bash
# スナップショットをコピーし、Hugo用データを生成
python Scripts/prepare_snapshot_catalog.py

# 既存のPNGをクリーンしてから実行
python Scripts/prepare_snapshot_catalog.py --clean

# ドライランモード（実際にファイルを変更せずに動作確認）
python Scripts/prepare_snapshot_catalog.py --dry-run
```

### オプション

| オプション | 説明 | デフォルト値 |
|-----------|------|------------|
| `--snapshots` | スナップショットPNGディレクトリ | `ProtoDesignSystemTests/__Snapshots__/PreviewTests.generated` |
| `--static-dir` | Hugo静的ファイル出力先 | `docs/static/snapshots` |
| `--data-file` | Hugoデータファイル出力先 | `docs/data/snapshots.json` |
| `--clean` | 実行前に既存のPNGを削除 | (なし) |
| `--dry-run` | 実際の変更を行わずプレビュー | (なし) |

### カスタムパスでの実行

```bash
python Scripts/prepare_snapshot_catalog.py \
  --snapshots /path/to/snapshots \
  --static-dir /path/to/output \
  --data-file /path/to/data.json
```

## 🧪 テスト

メタデータ抽出機能のテストを実行:

```bash
python Scripts/test_metadata_extraction.py
```

## 📊 生成されるデータ構造

### スナップショットファイル名の命名規則

スクリプトは以下のファイル名パターンからメタデータを自動抽出します:

```
ComponentName_variant_state_0.1.png
```

**例:**
- `Button_0.1.png` → component: Button
- `Button_small_0.1.png` → component: Button, variant: small
- `Button_small_hover_0.1.png` → component: Button, variant: small, state: hover
- `InputText_large_error_0.1.png` → component: InputText, variant: large, state: error

### 認識される状態（state）

- `default`, `hover`, `active`, `disabled`
- `focus`, `error`, `success`

### 認識されるサイズバリアント（variant）

- `small`, `medium`, `large`
- `xs`, `sm`, `md`, `lg`, `xl`

### 出力JSON構造

```json
{
  "generated_at": "2025-12-05 02:04 UTC",
  "total_snapshots": 15,
  "categories": {
    "Feedback": 2,
    "Form": 9,
    "Content": 3
  },
  "snapshots": [
    {
      "file": "Button_small_hover_0.1.png",
      "title": "Button small hover",
      "tags": ["button", "form", "hover", "small"],
      "component": "Button",
      "category": "Form",
      "variant": "small",
      "state": "hover"
    }
  ],
  "by_category": {
    "Form": [ /* Formカテゴリのスナップショット一覧 */ ],
    "Content": [ /* ... */ ],
    "Feedback": [ /* ... */ ]
  }
}
```

### フィールド説明

| フィールド | 型 | 説明 |
|-----------|-----|------|
| `file` | string | ファイル名 |
| `title` | string | 人間が読みやすいタイトル |
| `tags` | string[] | 検索・フィルタリング用タグ |
| `component` | string | コンポーネント名 |
| `category` | string | カテゴリ（Form, Content, Feedback, Other） |
| `variant` | string\|null | サイズバリアント |
| `state` | string\|null | 状態 |

## 📂 コンポーネントカテゴリマッピング

スクリプトは以下のマッピングでコンポーネントをカテゴリに分類します（`CLAUDE.md`に基づく）:

### Form（フォーム）
- Button, SolidFillButton, OutlineButton, TextButton
- Checkbox, RadioButton, SelectBox, SearchBox
- InputText, TextArea

### Content（コンテンツ）
- ChipLabel, ChipTag, UtilityLink

### Feedback（フィードバック）
- Banner, NotificationBanner, EmergencyBanner
- ProgressIndicator

### Other（その他）
- 上記に該当しないコンポーネント

## 🔄 ワークフロー統合

### CI/CD（GitHub Actions）

`.github/workflows/ui-snapshot-catalog.yml` で使用:

```yaml
- name: Prepare Hugo snapshot data
  run: |
    python Scripts/prepare_snapshot_catalog.py \
      --snapshots ProtoDesignSystemTests/__Snapshots__/PreviewTests.generated \
      --static-dir docs/static/snapshots \
      --data-file docs/data/snapshots.json \
      --clean
```

### ローカル開発

スナップショットテスト実行後に手動で実行:

```bash
# 1. Xcodeでスナップショットテストを実行
# 2. スクリプトを実行してHugoデータを更新
python Scripts/prepare_snapshot_catalog.py --clean

# 3. Hugo開発サーバーで確認
cd docs && hugo server
```

## 🛠 カスタマイズ

### 新しいカテゴリの追加

`prepare_snapshot_catalog.py` の `COMPONENT_CATEGORIES` 辞書を編集:

```python
COMPONENT_CATEGORIES = {
    "Button": "Form",
    "NewComponent": "NewCategory",  # 新しいマッピングを追加
    # ...
}
```

### 新しい状態・バリアントの認識

`extract_metadata()` 関数内の `known_states` と `known_sizes` セットを編集:

```python
known_states = {"default", "hover", "active", "disabled", "focus", "error", "success", "warning"}
known_sizes = {"small", "medium", "large", "xs", "sm", "md", "lg", "xl", "xxl"}
```

## 📝 今後の改善予定

Phase 2の実装計画（`Docs/Implementation-Plan-Snapshot-Catalog-Improvements.md`参照）:

- [ ] **ウォッチモード**: `--watch`オプションでファイル変更を自動監視
- [ ] **インクリメンタル更新**: 変更されたPNGのみ処理
- [ ] **検証機能**: `--validate`オプションでデータ整合性チェック

## 🐛 トラブルシューティング

### スナップショットディレクトリが見つからない

```
Snapshot directory not found: ProtoDesignSystemTests/__Snapshots__/PreviewTests.generated
```

→ Xcodeでスナップショットテストを実行し、PNGファイルを生成してください。

### カテゴリが "Other" になる

→ `COMPONENT_CATEGORIES` にコンポーネント名のマッピングを追加してください。

### メタデータが正しく抽出されない

→ ファイル名が `ComponentName_variant_state_0.1.png` のパターンに従っているか確認してください。
→ テストスクリプトで動作確認: `python Scripts/test_metadata_extraction.py`
