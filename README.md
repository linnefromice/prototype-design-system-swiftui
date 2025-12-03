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

スナップショットテストで生成されたUIプレビュー画像（`ProtoDesignSystemTests/__Snapshots__/PreviewTests.generated` 配下）をGitHub Pagesで閲覧できるようにするためのミニマム実装を追加しています。

- `Scripts/generate_snapshot_catalog.py` でスナップショット一覧の静的HTMLを生成します（デフォルトの出力先はスナップショット画像と同じ `ProtoDesignSystemTests/__Snapshots__/PreviewTests.generated`）。
- GitHub Actionsの **Deploy UI Snapshot Catalog** ワークフローが実行されると、`ProtoDesignSystemTests/__Snapshots__/PreviewTests.generated` をそのまま Pages に公開します（画像を `docs/` にコピーしません）。
- ローカルで確認する場合は、以下を実行して生成された `ProtoDesignSystemTests/__Snapshots__/PreviewTests.generated/index.html` をブラウザで開いてください。

```bash
python Scripts/generate_snapshot_catalog.py \
  --snapshots ProtoDesignSystemTests/__Snapshots__/PreviewTests.generated \
  --output ProtoDesignSystemTests/__Snapshots__/PreviewTests.generated
```
