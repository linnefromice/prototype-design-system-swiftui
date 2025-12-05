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
  - メタデータ抽出機能により、ファイル名からコンポーネント名、カテゴリ、バリアント、状態を自動抽出
  - `--dry-run` オプションで実行内容をプレビュー可能
- `.github/workflows/ui-snapshot-catalog.yml` で Hugo（`docs/`）をビルドし、`docs/public` を Pages にデプロイします。
- Hugo の設定は `docs/hugo.toml`、レイアウトは `docs/layouts/` にあります（シングルページの検索付きギャラリー）。

詳細は [Scripts/README.md](Scripts/README.md) を参照してください。

ローカルで動作確認する場合は Hugo をインストールした上で以下を実行してください。

```bash
# スナップショットをコピーしデータファイルを生成
python Scripts/prepare_snapshot_catalog.py --clean

# ドライランで確認
python Scripts/prepare_snapshot_catalog.py --dry-run

# サイトをビルド（出力先は docs/public）
hugo --source docs --destination docs/public --baseURL "http://localhost:1313/" --minify

# ローカルサーバで確認したい場合
hugo server --source docs --buildDrafts --baseURL "http://localhost:1313/"
```

## プロジェクト構成

### ディレクトリ構造

```
ProtoDesignSystem/
├── .prefire.yml              # Prefire設定（スナップショットテスト生成）
├── ProtoDesignSystem/        # メインアプリケーション
│   └── Sources/
│       └── DesignSystem/     # デザインシステムコンポーネント
├── ProtoDesignSystemTests/   # テスト
│   └── __Snapshots__/        # スナップショット画像
├── Scripts/                  # ビルド・デプロイスクリプト
│   ├── prepare_snapshot_catalog.py  # スナップショット→Hugoデータ変換
│   ├── test_metadata_extraction.py  # テストスクリプト
│   └── README.md            # スクリプトドキュメント
├── docs/                     # Hugoサイト（GitHub Pages）
│   ├── content/             # Hugoコンテンツ
│   ├── data/                # Hugoデータ（snapshots.json）
│   ├── layouts/             # Hugoレイアウト
│   └── static/              # 静的ファイル（スナップショット画像）
└── Prompts/                 # AI補助用プロンプト（Git管理対象外）
    └── Plan/                # 実装計画ドキュメント（Git管理対象）
```

### 重要なファイル

- `CLAUDE.md`: AI開発補助のためのプロジェクトガイド
- `COMPONENT_STATUS.md`: コンポーネント実装状況
- `Prompts/Plan/Implementation-Plan-Snapshot-Catalog-Improvements.md`: スナップショットカタログ改善計画
