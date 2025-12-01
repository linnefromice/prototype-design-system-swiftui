# コンポーネント実装ステータス

このドキュメントでは、デザインシステムのコンポーネント実装状況を管理します。

## スコープ

DADS (デジタル庁デザインシステム) をベースにしている

- https://design.digital.go.jp/dads/

## ステータス定義

- 🔴 **Not Started**: 未着手
- 🟡 **In Progress**: 実装中
- 🟢 **Completed**: 実装完了

---

## Content（コンテンツ）

| ステータス | コンポーネント名 | 英語名 | 説明 | パス |
|:---:|---|---|---|---|
| 🔴 | アコーディオン | Accordion | 開閉式の情報表示 | - |
| 🔴 | 引用ブロック | BlockQuote | 引用表示 | - |
| 🔴 | カード | Card | まとまりある情報ブロック | - |
| 🟢 | チップタグ | ChipTag | タグ型ラベル | `ProtoDesignSystem/Sources/DesignSystem/Components/Chip` |
| 🟢 | チップラベル | ChipLabel | 状態ラベル | `ProtoDesignSystem/Sources/DesignSystem/Components/Chip` |
| 🔴 | ディスクロージャー | Disclosure | 詳細開閉要素 | - |
| 🔴 | 説明リスト | DescriptionList | 定義リスト（dl） | - |
| 🔴 | リスト | List | 箇条書き（ul/ol） | - |
| 🔴 | リソースリスト | ResourceList | リンクを含む一覧 | - |

## Form（フォーム）

| ステータス | コンポーネント名 | 英語名 | 説明 | パス |
|:---:|---|---|---|---|
| 🟢 | インプットテキスト | InputText | 単一行のテキスト入力 | `ProtoDesignSystem/Sources/DesignSystem/Components/InputText` |
| 🔴 | 検索ボックス | SearchBox | 検索入力 | - |
| 🟢 | セレクトボックス | SelectBox | 選択式入力 | `ProtoDesignSystem/Sources/DesignSystem/Components/SelectBox` |
| 🟢 | チェックボックス | Checkbox | 複数選択 | `ProtoDesignSystem/Sources/DesignSystem/Components/Checkbox` |
| 🔴 | テキストエリア | TextArea | 複数行テキスト入力 | - |
| 🔴 | 日付ピッカー／カレンダー | DatePicker | 日付選択 | - |
| 🟢 | ボタン | Button | アクション実行 | `ProtoDesignSystem/Sources/DesignSystem/Components/Button` |
| 🔴 | ラジオボタン | RadioButton | 単一選択 | - |

## Feedback（フィードバック）

| ステータス | コンポーネント名 | 英語名 | 説明 | パス |
|:---:|---|---|---|---|
| 🟢 | 緊急時バナー | EmergencyBanner | 緊急性の高い通知 | `ProtoDesignSystem/Sources/DesignSystem/Components/Banner` |
| 🟢 | ノティフィケーションバナー | NotificationBanner | 一般的な通知 | `ProtoDesignSystem/Sources/DesignSystem/Components/Banner` |
| 🔴 | プログレスインジケーター | ProgressIndicator | 進行状況の表示 | - |
| 🔴 | モーダルダイアログ | ModalDialog | 重要な情報の強制表示 | - |

## Navigation（ナビゲーション）

| ステータス | コンポーネント名 | 英語名 | 説明 | パス |
|:---:|---|---|---|---|
| 🔴 | グローバルメニュー | GlobalMenu | サイト全体の主要ナビゲーション | - |
| 🔴 | スクロールトップボタン | ScrollToTopButton | ページ上部へ戻る | - |
| 🔴 | ステップナビゲーション | StepNavigation | 手続きの段階表示 | - |
| 🔴 | ドロワー | Drawer | サイドから出るメニュー | - |
| 🔴 | パンくずリスト | Breadcrumb | ページ階層の表示 | - |
| 🔴 | ハンバーガーメニューボタン | HamburgerMenuButton | モバイルメニューの開閉 | - |
| 🔴 | ページナビゲーション | Pagination | ページ送り | - |
| 🔴 | ボトムナビゲーション | BottomNavigation | モバイルで下部に表示 | - |
| 🔴 | メガメニュー | MegaMenu | 大規模メニュー | - |
| 🔴 | メニューリスト | MenuList | リスト型メニュー | - |
| 🔴 | メニューリストボックス | MenuListBox | ボックス型メニュー | - |
| 🔴 | モバイルメニュー | MobileMenu | モバイル用のメニュー領域 | - |
| 🟢 | ユーティリティリンク | UtilityLink | 補助的なリンク集 | `ProtoDesignSystem/Sources/DesignSystem/Components/UtilityLink` |
| 🔴 | ランゲージセレクター | LanguageSelector | 言語切替 | - |

## Layout（レイアウト）

| ステータス | コンポーネント名 | 英語名 | 説明 | パス |
|:---:|---|---|---|---|
| 🔴 | ディバイダー | Divider | 区切り線 | - |
| 🔴 | ヘッダーコンテナ | HeaderContainer | サイト最上部の構造 | - |

## Table（テーブル）

| ステータス | コンポーネント名 | 英語名 | 説明 | パス |
|:---:|---|---|---|---|
| 🔴 | テーブルコントロール | TableControl | 表の操作要素 | - |
| 🔴 | テーブル／データテーブル | DataTable | データ一覧表示 | - |

---

## 更新履歴

- 2025-12-01: Banner実装完了（NotificationBanner/EmergencyBanner統合、5ステータス、2バリアント、2レイアウト）
- 2025-12-01: ChipTag実装完了（4つの状態、5色のカラーバリエーション、削除ボタン、FlowLayout対応）
- 2025-12-01: ChipLabel実装完了（4種類のスタイル、9色のカラーバリエーション、アクセシビリティ対応）
- 2025-11-30: SelectBoxをリファクタリング（ジェネリック型サポート、エラー状態、アクセシビリティ対応を追加）
- 2025-11-30: 自動更新（実装済み: 5コンポーネント）
- 2025-11-30: 初版作成、既存実装状況を反映（Button, Checkbox, InputText, SelectBox, UtilityLink）
