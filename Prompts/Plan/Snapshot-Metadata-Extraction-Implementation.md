# スナップショットメタデータ抽出機能の実装

## 📌 概要

スナップショットPNGファイルから構造化メタデータを自動抽出し、Hugo用のUIカタログデータを生成する機能を実装しました。

**実装日**: 2025-12-05
**関連計画**: `Implementation-Plan-Snapshot-Catalog-Improvements.md` Phase 2

## 🎯 実装内容

### 1. メタデータ抽出機能

**ファイル**: `Scripts/prepare_snapshot_catalog.py`

#### 抽出される情報

| フィールド | 説明 | 例 |
|-----------|------|-----|
| `component` | コンポーネント名 | "Button" |
| `category` | カテゴリ（Form/Content/Feedback/Other） | "Form" |
| `variant` | サイズバリアント | "small", "large" など |
| `state` | 状態 | "hover", "disabled", "error" など |
| `title` | 人間が読みやすいタイトル | "Button small hover" |
| `tags` | 検索用タグ配列 | ["button", "form", "small", "hover"] |

#### ファイル名パターン認識

```
ComponentName_variant_state_0.1.png
```

**例:**
- `Button_0.1.png` → component: Button
- `Button_small_hover_0.1.png` → component: Button, variant: small, state: hover
- `InputText_large_error_0.1.png` → component: InputText, variant: large, state: error

### 2. 強化されたJSON出力構造

従来の単純なリスト形式から、カテゴリ別グルーピングを含む構造化データに拡張:

```json
{
  "generated_at": "2025-12-05 02:04 UTC",
  "total_snapshots": 15,
  "categories": {
    "Feedback": 2,
    "Form": 9,
    "Content": 3,
    "Other": 1
  },
  "snapshots": [ /* 全スナップショットのメタデータ */ ],
  "by_category": {
    "Form": [ /* Formカテゴリのみ */ ],
    "Content": [ /* Contentカテゴリのみ */ ],
    "Feedback": [ /* Feedbackカテゴリのみ */ ]
  }
}
```

### 3. 新機能の追加

#### ドライランモード

```bash
python Scripts/prepare_snapshot_catalog.py --dry-run
```

実際にファイルを変更せず、実行内容をプレビュー表示。

#### カテゴリマッピング

CLAUDE.mdのコンポーネント分類に基づく自動カテゴリ割り当て:

```python
COMPONENT_CATEGORIES = {
    "Button": "Form",
    "SolidFillButton": "Form",
    "OutlineButton": "Form",
    # ... 他のコンポーネント
}
```

### 4. テストスイート

**ファイル**: `Scripts/test_metadata_extraction.py`

6つのテストケースで以下のパターンを検証:
- シンプルなコンポーネント名のみ
- サイズバリアント付き
- 状態付き
- バリアント + 状態の組み合わせ
- 未知のコンポーネント（Otherカテゴリ）

全テスト通過を確認済み。

## 📊 実装前後の比較

### 従来のデータ構造

```json
{
  "generated_at": "2025-12-03 15:16 UTC",
  "snapshots": [
    {
      "file": "Button_0.1.png",
      "title": "Button 0.1",
      "tags": ["0.1", "button"]
    }
  ]
}
```

**問題点**:
- バージョン番号（0.1）がタグに含まれる
- コンポーネント情報が抽出されていない
- カテゴリ分類なし
- バリアントや状態の情報が失われる

### 改善後のデータ構造

```json
{
  "generated_at": "2025-12-05 02:04 UTC",
  "total_snapshots": 15,
  "categories": {
    "Feedback": 2,
    "Form": 9,
    "Content": 3,
    "Other": 1
  },
  "snapshots": [
    {
      "file": "Button_0.1.png",
      "title": "Button",
      "tags": ["button", "form"],
      "component": "Button",
      "category": "Form",
      "variant": null,
      "state": null
    }
  ],
  "by_category": { /* ... */ }
}
```

**改善点**:
- ✅ 構造化されたメタデータ
- ✅ カテゴリ別グルーピング
- ✅ 検索・フィルタリングに有用なタグ
- ✅ バリアントと状態の明示的な分離
- ✅ 統計情報（total_snapshots, categories）

## 🚀 使用例

### 基本的な実行

```bash
# スナップショットからHugoデータを生成
python Scripts/prepare_snapshot_catalog.py --clean
```

出力:
```
✓ Copied 15 snapshots to docs/static/snapshots
✓ Wrote data file to docs/data/snapshots.json
```

### ドライランで動作確認

```bash
python Scripts/prepare_snapshot_catalog.py --dry-run
```

出力:
```
============================================================
DRY RUN MODE - No files will be modified
============================================================
[DRY RUN] Would copy: Button_0.1.png -> docs/static/snapshots/Button_0.1.png
...
Preview of generated data:
{
  "generated_at": "2025-12-05 02:04 UTC",
  "total_snapshots": 15,
  ...
}

✓ Would process 15 snapshots
```

### テスト実行

```bash
python Scripts/test_metadata_extraction.py
```

出力:
```
============================================================
Testing Metadata Extraction
============================================================

Test 1: Button_0.1.png
  Component: Button (expected: Button)
  Category:  Form (expected: Form)
  ✓ PASSED

...

Results: 6 passed, 0 failed out of 6 tests
```

## 🎨 Hugo テンプレートでの活用例

### カテゴリ別表示

```html
{{ $data := .Site.Data.snapshots }}

{{ range $category, $items := $data.by_category }}
<section>
  <h2>{{ $category }}</h2>
  <div class="grid">
    {{ range $items }}
    <div class="snapshot-card">
      <img src="/snapshots/{{ .file }}" alt="{{ .title }}">
      <h3>{{ .title }}</h3>
      <div class="tags">
        {{ range .tags }}
        <span class="tag">{{ . }}</span>
        {{ end }}
      </div>
    </div>
    {{ end }}
  </div>
</section>
{{ end }}
```

### 検索フィルタリング

```javascript
// snapshots.json のデータを使って検索
const snapshots = {{ .Site.Data.snapshots.snapshots | jsonify }};

function filterByTag(tag) {
  return snapshots.filter(s => s.tags.includes(tag));
}

function filterByCategory(category) {
  return snapshots.filter(s => s.category === category);
}

function filterByState(state) {
  return snapshots.filter(s => s.state === state);
}
```

## 📈 統計情報

現在のスナップショット構成（2025-12-05時点）:

| カテゴリ | コンポーネント数 |
|---------|----------------|
| Form | 9 |
| Content | 3 |
| Feedback | 2 |
| Other | 1 |
| **合計** | **15** |

## 🔧 技術的詳細

### メタデータ抽出アルゴリズム

```python
def extract_metadata(filename: str) -> SnapshotMetadata:
    # 1. 拡張子を除去
    base = filename.rsplit(".", 1)[0]

    # 2. バージョンサフィックス（_0.1）を除去
    base = re.sub(r"_\d+\.\d+$", "", base)

    # 3. アンダースコアで分割
    parts = base.split("_")

    # 4. 最初の部分がコンポーネント名
    component = parts[0]

    # 5. カテゴリマッピングから分類
    category = COMPONENT_CATEGORIES.get(component, "Other")

    # 6. 残りの部分からvariantとstateを識別
    # known_states: {"hover", "disabled", "error", ...}
    # known_sizes: {"small", "medium", "large", ...}
    # ...
```

### 型定義（TypedDict）

```python
class SnapshotMetadata(TypedDict):
    """Metadata extracted from snapshot filename and component info."""
    file: str
    title: str
    tags: list[str]
    component: str
    category: str
    variant: str | None
    state: str | None
```

## 🐛 既知の制限事項と今後の改善

### 現在の制限

1. **ファイル名パターンの厳密性**: `ComponentName_variant_state_0.1.png` の形式に依存
2. **複数状態の同時指定**: 現在は1つの状態のみサポート（例: `hover_disabled` は未対応）
3. **手動カテゴリマッピング**: 新しいコンポーネント追加時に `COMPONENT_CATEGORIES` の更新が必要

### Phase 2 実装計画（残タスク）

実装計画（`Implementation-Plan-Snapshot-Catalog-Improvements.md`）で予定されていた機能のうち、以下は未実装:

- [ ] **ウォッチモード**: `--watch`オプションでファイル変更を監視
- [ ] **インクリメンタル更新**: 変更されたPNGのみ処理
- [ ] **検証機能**: `--validate`オプションでデータ整合性チェック

### 今後の拡張案

1. **Prefireとの統合**: Prefire設定ファイルからコンポーネント情報を読み取り
2. **多言語対応**: タイトルやタグの日本語対応
3. **画像メタデータ**: PNG EXIFデータからサイズや生成日時を取得
4. **差分検出**: 前回生成時からの変更を検出してレポート

## 📚 関連ドキュメント

- [実装計画](Implementation-Plan-Snapshot-Catalog-Improvements.md) - Phase 2全体の計画
- [スクリプトREADME](../Scripts/README.md) - 使い方とカスタマイズ方法
- [CLAUDE.md](../CLAUDE.md) - コンポーネント分類の定義元

## ✅ 実装完了チェックリスト

- [x] メタデータ抽出ロジックの実装
- [x] カテゴリマッピングの定義
- [x] JSON出力構造の拡張（by_category追加）
- [x] ドライランモードの実装
- [x] テストスイートの作成
- [x] 全テストケースの通過確認
- [x] ドキュメント作成（Scripts/README.md）
- [x] 実装レポート作成（本ドキュメント）

## 🎉 成果

**Phase 2の主要目標「メタデータ抽出の強化」を完了しました。**

- ✅ ファイル名から構造化情報を自動抽出
- ✅ コンポーネント、バリアント、状態を明示的に分離
- ✅ カテゴリ別グルーピング
- ✅ Hugo テンプレートで柔軟に活用可能
- ✅ 検索・フィルタリング機能の基盤を構築

これにより、スナップショットテストの画像から自動的にUIカタログを生成する基盤が整いました。
