# コンポーネント実装難易度ガイド

このドキュメントでは、未実装コンポーネントを難易度順に整理し、次に着手すべきコンポーネントの選定をサポートします。

## 難易度の定義

- 🟩 **Very Easy**: 単純なスタイリングのみ、状態管理なし（1-2時間）
- 🟨 **Easy**: 既存パターンの応用、簡単な状態管理（2-4時間）
- 🟧 **Medium**: 複雑な状態管理、アニメーション、複数の子要素（4-8時間）
- 🟥 **Hard**: 複雑なインタラクション、高度なレイアウト、外部データ統合（8時間以上）

---

## 🟩 Very Easy（極めて低い難易度）

最初に着手すべき優先度の高いコンポーネント

| 優先度 | コンポーネント名 | 英語名 | 理由 | カテゴリ |
|:---:|---|---|---|---|
| ⭐⭐⭐ | ディバイダー | Divider | Rectangle + 色指定のみ。最もシンプル | Layout |
| ⭐⭐⭐ | 引用ブロック | BlockQuote | テキスト + 左ボーダー + 背景色のみ | Content |
| ⭐⭐ | リスト | List | ul/ol のスタイリング。VStack + マーカー | Content |

**推奨実装順序**: Divider → BlockQuote → List

---

## 🟨 Easy（低い難易度）

基本的なコンポーネントパターンを理解していれば実装可能

| 優先度 | コンポーネント名 | 英語名 | 理由 | カテゴリ |
|:---:|---|---|---|---|
| ⭐⭐⭐ | ラジオボタン | RadioButton | Checkboxとほぼ同じパターン。単一選択のロジック追加 | Form |
| ⭐⭐⭐ | テキストエリア | TextArea | InputTextの複数行版。TextEditorを使用 | Form |
| ⭐⭐ | 説明リスト | DescriptionList | dl/dt/dd のスタイリング。VStack + HStack | Content |
| ⭐⭐ | カード | Card | コンテナ + 角丸 + シャドウ。汎用性高い | Content |
| ⭐⭐ | プログレスインジケーター | ProgressIndicator | ProgressView + スタイリング | Feedback |
| ⭐ | スクロールトップボタン | ScrollToTopButton | Button + ScrollViewReader | Navigation |
| ⭐ | リソースリスト | ResourceList | List + Link。リンク付きリスト表示 | Content |

**推奨実装順序**: RadioButton → TextArea → Card → DescriptionList

---

## 🟧 Medium（中程度の難易度）

状態管理やアニメーションが必要なコンポーネント

| 優先度 | コンポーネント名 | 英語名 | 理由 | カテゴリ |
|:---:|---|---|---|---|
| ⭐⭐⭐ | アコーディオン | Accordion | 開閉状態の管理。DisclosureGroupを使用可能 | Content |
| ⭐⭐⭐ | ディスクロージャー | Disclosure | 開閉状態の管理。アコーディオンの単体版 | Content |
| ⭐⭐ | 検索ボックス | SearchBox | InputText + 検索アイコン + クリアボタン | Form |
| ⭐⭐ | ノティフィケーションバナー | NotificationBanner | バナー表示 + 閉じるボタン + アニメーション | Feedback |
| ⭐⭐ | 緊急時バナー | EmergencyBanner | NotificationBannerの強調版 | Feedback |
| ⭐⭐ | パンくずリスト | Breadcrumb | リンクの連鎖表示。HStack + 区切り記号 | Navigation |
| ⭐⭐ | ページナビゲーション | Pagination | ページ番号の管理と表示 | Navigation |
| ⭐ | ランゲージセレクター | LanguageSelector | SelectBoxの特化版。言語切替 | Navigation |
| ⭐ | ハンバーガーメニューボタン | HamburgerMenuButton | アニメーション付きボタン（3本線 ⇔ ×） | Navigation |
| ⭐ | 日付ピッカー／カレンダー | DatePicker | DatePickerを使用。スタイリングが必要 | Form |

**推奨実装順序**: Disclosure → Accordion → SearchBox → NotificationBanner

---

## 🟥 Hard（高い難易度）

複雑なレイアウトや高度なインタラクションが必要

| コンポーネント名 | 英語名 | 理由 | カテゴリ |
|---|---|---|---|
| ステップナビゲーション | StepNavigation | 複数ステップの状態管理、進捗表示 | Navigation |
| ドロワー | Drawer | スライドアニメーション + オーバーレイ + フォーカス管理 | Navigation |
| モーダルダイアログ | ModalDialog | オーバーレイ + フォーカストラップ + アクセシビリティ | Feedback |
| グローバルメニュー | GlobalMenu | 複雑なナビゲーション構造、レスポンシブ対応 | Navigation |
| メガメニュー | MegaMenu | 大規模メニュー + サブメニュー + レイアウト | Navigation |
| メニューリスト | MenuList | メニュー項目の管理、キーボード操作 | Navigation |
| メニューリストボックス | MenuListBox | MenuListのボックス版、フォーカス管理 | Navigation |
| モバイルメニュー | MobileMenu | レスポンシブ対応、アニメーション | Navigation |
| ボトムナビゲーション | BottomNavigation | タブ管理、選択状態の管理 | Navigation |
| ヘッダーコンテナ | HeaderContainer | 複雑なレイアウト、スクロール時の動作 | Layout |
| テーブルコントロール | TableControl | テーブル操作（ソート、フィルター） | Table |
| テーブル／データテーブル | DataTable | ソート、フィルター、ページング、行選択 | Table |

**推奨実装順序**: ModalDialog → Drawer → StepNavigation → DataTable

---

## 実装推奨ロードマップ

### フェーズ1: 基礎固め（Very Easy + Easy）
1. ✅ **Divider** - 最もシンプル、すぐ完了
2. ✅ **BlockQuote** - テキストスタイリングの練習
3. ✅ **List** - リスト表示の基本
4. ✅ **RadioButton** - Checkboxの応用
5. ✅ **TextArea** - InputTextの応用
6. ✅ **Card** - 汎用性が高く使用頻度も高い

### フェーズ2: インタラクション強化（Easy + Medium）
7. ✅ **DescriptionList** - リスト系の完成
8. ✅ **Disclosure** - 開閉UIの基本
9. ✅ **Accordion** - 複数Disclosureの管理
10. ✅ **SearchBox** - フォーム系の完成
11. ✅ **NotificationBanner** - フィードバックUI
12. ✅ **Breadcrumb** - ナビゲーションの基本

### フェーズ3: ナビゲーション拡充（Medium）
13. ✅ **Pagination** - ページ管理
14. ✅ **LanguageSelector** - 言語切替
15. ✅ **HamburgerMenuButton** - モバイル対応
16. ✅ **ScrollToTopButton** - スクロール制御

### フェーズ4: 高度な機能（Hard）
17. ✅ **ModalDialog** - オーバーレイUIの基本
18. ✅ **Drawer** - サイドメニュー
19. ✅ **DataTable** - 複雑なデータ表示
20. その他の高難易度コンポーネント

---

## 次に実装すべきコンポーネント TOP 3

### 🥇 1位: Divider（ディバイダー）
- **難易度**: 🟩 Very Easy
- **実装時間**: 30分-1時間
- **理由**: 最もシンプルで、他コンポーネントでも頻繁に使用
- **学習効果**: デザイントークンの使い方を復習

### 🥈 2位: BlockQuote（引用ブロック）
- **難易度**: 🟩 Very Easy
- **実装時間**: 1-2時間
- **理由**: テキストスタイリングの基本、MDXなどでも有用
- **学習効果**: ボーダー、パディング、背景色の組み合わせ

### 🥉 3位: RadioButton（ラジオボタン）
- **難易度**: 🟨 Easy
- **実装時間**: 2-3時間
- **理由**: Checkboxの経験を活かせる、フォーム系の充実
- **学習効果**: 単一選択のロジック、グループ管理

---

## カテゴリ別の難易度サマリー

| カテゴリ | Very Easy | Easy | Medium | Hard | 合計 |
|---|:---:|:---:|:---:|:---:|:---:|
| Content | 3 | 2 | 2 | 0 | 7 |
| Form | 0 | 2 | 2 | 0 | 4 |
| Feedback | 0 | 1 | 2 | 1 | 4 |
| Navigation | 0 | 1 | 5 | 7 | 13 |
| Layout | 1 | 0 | 0 | 1 | 2 |
| Table | 0 | 0 | 0 | 2 | 2 |
| **合計** | **4** | **6** | **11** | **11** | **32** |

---

## 更新履歴

- 2025-12-01: 初版作成、全32未実装コンポーネントを難易度別に分類
