# prototype-design-system-swiftui

SwiftUIベースのデザインシステム実装プロトタイプ

## コンポーネント実装状況

コンポーネントの実装ステータスは以下のファイルで管理されています：

- **[COMPONENT_STATUS.md](./COMPONENT_STATUS.md)** - 実装状況の詳細（カテゴリ別、視覚的なステータス表示）
- **[component_status.csv](./component_status.csv)** - CSV形式のステータス管理（スプレッドシートでの編集可能）
- **[COMPONENT_TRACKING.md](./COMPONENT_TRACKING.md)** - ステータス管理ガイド（更新方法、ワークフロー等）

### 現在の進捗

- 全39コンポーネント中5コンポーネント実装済み (12.8%)
- 実装済み: Button, Checkbox, InputText, SelectBox, UtilityLink

### ステータス確認コマンド

```bash
# サマリー表示
make status

# カテゴリ別詳細表示
make status-detail
```

### コンポーネント実装完了時の手順

新しいコンポーネントの実装が完了したら、必ず `COMPONENT_STATUS.md` を更新してください：

1. **ステータスの更新**: 該当コンポーネントのステータスを 🟢（Completed）に変更
2. **パスの追加**: 実装ファイルのパスを追加（例: `ProtoDesignSystem/Sources/DesignSystem/Components/ComponentName`）
3. **更新履歴の追記**: 最新の更新を一番上に追加（形式: `- YYYY-MM-DD: コンポーネント名の実装完了（主な特徴）`）

詳細な更新方法については [COMPONENT_STATUS.md](./COMPONENT_STATUS.md) の「更新履歴」セクションを参照してください。

## UI Snapshot Catalog

`docs/` 配下に Hugo で構築したスナップショットカタログを置いています。スナップショットテストの PNG をコピーして Hugo のデータに変換し、GitHub Pages で公開します。

- `Scripts/prepare_snapshot_catalog.py` が PNG を `docs/static/snapshots` にコピーし、Hugo 用のデータ `docs/data/snapshots.json` を生成します。
- `.github/workflows/ui-snapshot-catalog.yml` で Hugo（`docs/`）をビルドし、`docs/public` を Pages にデプロイします。
- Hugo の設定は `docs/hugo.toml`、レイアウトは `docs/layouts/` にあります（シングルページの検索付きギャラリー）。

ローカルで動作確認する場合は Hugo をインストールした上で以下を実行してください。

```bash
# スナップショットをコピーしデータファイルを生成
python Scripts/prepare_snapshot_catalog.py \
  --snapshots ProtoDesignSystemTests/__Snapshots__/PreviewTests.generated \
  --static-dir docs/static/snapshots \
  --data-file docs/data/snapshots.json \
  --clean

# サイトをビルド（出力先は docs/public）
hugo --source docs --destination docs/public --baseURL "http://localhost:1313/" --minify

# ローカルサーバで確認したい場合
hugo server --source docs --buildDrafts --baseURL "http://localhost:1313/"
```
