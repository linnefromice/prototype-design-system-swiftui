# スナップショットカタログ改善実装計画

## 概要

CI/CDワークフローを改善し、スナップショットテストからGitHub Pagesへの自動デプロイを効率化します。

## 背景

### 現在の構成

1. **スナップショット生成場所**: `ProtoDesignSystemTests/__Snapshots__/PreviewTests.generated/`
2. **現在のフロー**:
   - CI実行時にスナップショットPNGを`docs/static/snapshots/`にコピー
   - Pythonスクリプト(`prepare_snapshot_catalog.py`)でHugoデータ(`docs/data/snapshots.json`)を生成
   - Hugo でビルド→GitHub Pages へデプロイ

3. **Prefireの状態**: 現在、`.prefire.yml`設定ファイルは存在していない

### 検討事項

#### [1] Prefireで直接docs配下に出力できるか？

**結論**: ❌ **不可能**

Prefireの`test_target_path`は**テストターゲットのディレクトリ**を指定するパラメータであり、スナップショット出力先は `{test_target_path}/__Snapshots__/` に固定されます。

**代替案**:

**Option A: シンボリックリンクを使用**
```bash
# ProtoDesignSystemTests/__Snapshots__ -> docs/static/snapshots へのシンボリックリンク
ln -s ../../docs/static/snapshots ProtoDesignSystemTests/__Snapshots__/PreviewTests.generated
```
- メリット: Prefireの出力がそのままdocs配下に反映される
- デメリット: Gitでのシンボリックリンク管理、CI環境での互換性に注意が必要

**Option B: 現在の方式を維持（推奨）**
- Prefireは通常の場所に出力
- CI/ローカルスクリプトで`docs/static/snapshots/`にコピー
- メリット: 明確な責任分離、トラブルシューティングが容易

#### [2] Hugo用設定ファイルの自動生成スクリプトについて

**結論**: ✅ **実装可能**

現在の`prepare_snapshot_catalog.py`を改善・拡張することで実現できます。

**現状の問題点**:
1. PNGファイルのコピー処理がCI内に組み込まれている
2. ローカル開発時にも同じスクリプトを実行したい
3. スナップショット更新→Hugo再ビルドのフローが手動

**改善案**:
1. **ウォッチモード追加**: ファイル変更を監視して自動的にデータ生成
2. **メタデータ抽出の強化**: ファイル名から構造化情報（コンポーネント名、バリアント、状態など）を抽出
3. **Makefile統合**: `make dev`で監視モード起動、`make build`でビルド一式実行

---

## Phase 1: Prefire設定ファイルの導入

### 目的
プロジェクトにPrefire設定を明示的に定義し、スナップショット生成の挙動を標準化

### 実装内容

**1. `.prefire.yml` の作成**

```yaml
test_configuration:
  target: ProtoDesignSystemTests
  test_target_path: ${PROJECT_DIR}/ProtoDesignSystemTests
  test_file_path: ProtoDesignSystemTests/PreviewTests.generated.swift
  simulator_device: "iPhone15,2"
  required_os: 16
  preview_default_enabled: true
  use_grouped_snapshots: true
  sources:
    - ${PROJECT_DIR}/ProtoDesignSystem/Sources/
  snapshot_devices:
    - iPhone 14
    - iPad
  imports:
    - SwiftUI
  testable_imports:
    - ProtoDesignSystem
```

**影響範囲**:
- スナップショット出力先は変更なし（`ProtoDesignSystemTests/__Snapshots__/PreviewTests.generated/`）
- あくまでスナップショット生成の標準化のための設定

---

## Phase 2: スナップショット処理スクリプトの改善

### 目的
PNG→Hugoデータ生成を自動化し、ローカル開発体験を向上

### 実装内容

**1. `Scripts/prepare_snapshot_catalog.py` の機能拡張**

追加機能:
- ✅ **ウォッチモード**: `--watch`オプションでファイル変更を監視
- ✅ **メタデータ抽出の強化**: ファイル名パース（例: `Button_small_hover_0.1.png` → コンポーネント、サイズ、状態を抽出）
- ✅ **インクリメンタル更新**: 変更されたPNGのみ処理
- ✅ **ドライランモード**: `--dry-run`で実行内容をプレビュー

**出力データ構造（拡張版）**:
```json
{
  "generated_at": "2025-12-04 15:30 UTC",
  "snapshots": [
    {
      "file": "Button_small_hover_0.1.png",
      "title": "Button small hover",
      "tags": ["button", "small", "hover"],
      "component": "Button",
      "variant": "small",
      "state": "hover"
    }
  ]
}
```

**依存ライブラリ**:
```bash
pip install watchdog
```

**2. 新規スクリプト: `Scripts/watch_snapshots.sh`**

```bash
#!/bin/bash
# スナップショット監視 + Hugoライブリロード統合
python Scripts/prepare_snapshot_catalog.py --watch &
cd docs && hugo server --bind 0.0.0.0
```

**ウォッチモード実装イメージ**:

```python
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

class SnapshotHandler(FileSystemEventHandler):
    def on_created(self, event):
        if event.src_path.endswith('.png'):
            print(f"新しいスナップショット検出: {event.src_path}")
            # → コピー処理実行
            # → JSONデータ更新

    def on_modified(self, event):
        if event.src_path.endswith('.png'):
            print(f"スナップショット更新: {event.src_path}")
            # → 同上

# ProtoDesignSystemTests/__Snapshots__/ を監視
observer = Observer()
observer.schedule(SnapshotHandler(), path="ProtoDesignSystemTests/__Snapshots__", recursive=True)
observer.start()
```

---

## Phase 3: Makefile統合

### 目的
開発者が簡単にスナップショットカタログを起動・ビルドできるようにする

### 実装内容

**Makefile への追加ターゲット**:

```makefile
# スナップショットカタログ開発サーバー起動
.PHONY: catalog-dev
catalog-dev:
	@echo "Starting snapshot catalog in watch mode..."
	@Scripts/watch_snapshots.sh

# スナップショットカタログビルド（CI用）
.PHONY: catalog-build
catalog-build:
	@echo "Building snapshot catalog..."
	@python Scripts/prepare_snapshot_catalog.py \
		--snapshots ProtoDesignSystemTests/__Snapshots__/PreviewTests.generated \
		--static-dir docs/static/snapshots \
		--data-file docs/data/snapshots.json \
		--clean
	@cd docs && hugo --minify

# スナップショットのクリーン
.PHONY: catalog-clean
catalog-clean:
	@echo "Cleaning snapshot catalog..."
	@rm -rf docs/static/snapshots/*.png
	@rm -f docs/data/snapshots.json
```

**使用例**:

```bash
# ローカル開発（ウォッチモード）
make catalog-dev

# ビルド
make catalog-build

# クリーン
make catalog-clean
```

---

## Phase 4: CI/CDワークフロー最適化

### 目的
GitHub ActionsでPrefireの設定を活用し、ビルド効率を向上

### 実装内容

**`.github/workflows/ui-snapshot-catalog.yml` の改善**:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      # ... (既存のsteps)

      # Prefireを使ったスナップショット生成（オプション）
      # 現在はXcodeで手動生成しているため、CI内での生成を追加する場合
      # - name: Run Prefire snapshot tests
      #   run: |
      #     xcodebuild test \
      #       -project ProtoDesignSystem.xcodeproj \
      #       -scheme ProtoDesignSystemTests \
      #       -destination 'platform=iOS Simulator,name=iPhone 15'

      - name: Prepare Hugo snapshot data
        run: |
          python Scripts/prepare_snapshot_catalog.py \
            --snapshots ProtoDesignSystemTests/__Snapshots__/PreviewTests.generated \
            --static-dir docs/static/snapshots \
            --data-file docs/data/snapshots.json \
            --clean \
            --validate  # 新オプション: データ整合性チェック
```

---

## Phase 5: ドキュメント更新

### 実装内容

**1. `README.md` または `CLAUDE.md` への追記**:

```markdown
## スナップショットカタログの開発

### ローカル開発

\`\`\`bash
# カタログ開発サーバー起動（ウォッチモード）
make catalog-dev

# ブラウザで http://localhost:1313 にアクセス
\`\`\`

### CI/CD

スナップショットPNGの更新は以下のフローで自動的にGitHub Pagesに反映されます:
1. Xcodeでスナップショットテストを実行
2. `ProtoDesignSystemTests/__Snapshots__/` に更新されたPNGをコミット
3. GitHub Actionsが`prepare_snapshot_catalog.py`を実行
4. Hugo でビルド → GitHub Pagesにデプロイ
```

---

## 実装優先順位

| Phase | 優先度 | 所要時間（目安） | 依存関係 |
|-------|--------|------------------|----------|
| Phase 1 | 中 | 10分 | なし |
| Phase 2 | 高 | 1-2時間 | なし |
| Phase 3 | 高 | 30分 | Phase 2 |
| Phase 4 | 中 | 30分 | Phase 2 |
| Phase 5 | 低 | 20分 | Phase 3 |

**推奨実装順序**: Phase 2 → Phase 3 → Phase 1 → Phase 4 → Phase 5

---

## 技術的考慮事項

### Prefireの制約について
- `test_target_path`でスナップショット出力先を`docs/`に直接指定することは**不可能**
- 現在のアプローチ（テスト実行→コピー→Hugo生成）を維持することを推奨
- Prefireの設定ファイルは、あくまでスナップショット生成の**標準化**のために導入

### ウォッチモードについて

**ウォッチモード（Watch Mode）**は、ファイルシステムの変更を監視して、変更が検出されたら自動的に処理を実行する機能です。

**現在の手動フロー**:
```bash
# 1. Xcodeでスナップショットテストを実行
# → ProtoDesignSystemTests/__Snapshots__/PreviewTests.generated/*.png が更新される

# 2. 手動でスクリプト実行
python Scripts/prepare_snapshot_catalog.py --clean

# 3. 手動でHugo再起動
cd docs && hugo server

# 4. ブラウザでリロード
```

**ウォッチモード導入後の自動フロー**:
```bash
# 一度だけ起動
make catalog-dev

# → バックグラウンドでファイル変更を監視
# → Xcodeでスナップショットテストを実行すると...
#   ✓ PNGファイルの変更を自動検出
#   ✓ docs/static/snapshots/ に自動コピー
#   ✓ docs/data/snapshots.json を自動生成
#   ✓ Hugoが自動リロード
#   ✓ ブラウザが自動リフレッシュ（Hugo Live Reload）
```

**メリット**:
1. **開発効率向上**: スクリプト実行を忘れない
2. **即座にフィードバック**: テスト実行→UIカタログ更新が数秒で完了
3. **ヒューマンエラー削減**: 手動コマンド実行ミスがなくなる

### Hugo との統合
- Hugoの`hugo server`は`docs/data/`の変更を自動検知してリロード
- スクリプトがJSONを更新すれば、ブラウザに即座に反映される

---

## まとめ

### 質問への回答

**[1] Prefireで直接docs配下に出力できるか？**
→ **❌ 不可能**: Prefireの`test_target_path`はテストディレクトリのルートを指定するもので、スナップショット出力先は`__Snapshots__/`に固定されます。現在の「コピー方式」を維持することを推奨します。

**[2] PNG→Hugo設定ファイルの自動生成スクリプトは可能か？**
→ **✅ 可能**: 既存の`prepare_snapshot_catalog.py`を拡張し、ウォッチモード・メタデータ抽出・インクリメンタル更新などの機能を追加できます。

### 推奨実装アプローチ

**優先度High（即効性あり）**:
- Phase 2: スクリプト改善（ウォッチモード、メタデータ抽出）
- Phase 3: Makefile統合（`make catalog-dev`で開発サーバー起動）

**優先度Medium（標準化）**:
- Phase 1: `.prefire.yml`作成（スナップショット生成設定の明示化）
- Phase 4: CI/CDワークフロー最適化

**優先度Low（ドキュメント）**:
- Phase 5: 開発ガイド更新
