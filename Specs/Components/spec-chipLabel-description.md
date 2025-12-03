# 📘 Chip Label（チップラベル）— 機能要件（DADS準拠）

本資料は、デジタル庁デザインシステム（DADS）の
Chip Label / チップラベルコンポーネントの機能要件を
SwiftUI 実装向けに整理したものである。

Chip Label は「状態・カテゴリ・タグ的用途のミニラベル」であり、
DADS では多数のカラーバリエーションと 4 種のスタイルが定義されている。

⸻

## 1. 概要

Chip Label は以下の特徴を持つコンポーネント：
	•	小型のラベル表示
	•	カラー・カテゴリ分け
	•	アイコンとテキストの組み合わせ
	•	タスクの進捗、ステータス、分類などの表現に使用

ロールは「装飾ラベル」でクリック/選択操作は不要（ChipTag と違う）。

⸻

## 2. 表示スタイル（Variants）

Chip Label には 4 種類の表示スタイル がある：

### ① Text Only
	•	枠線なし
	•	背景なし
	•	テキストのみ
	•	テキスト前に斜線パターンアイコン（DADSの識別アイコン）

### ② Outlined
	•	枠線あり（カラートークン反映）
	•	背景は白
	•	テキスト + 斜線アイコン

### ③ Outlined with Fill
	•	枠線あり（カラー）
	•	背景が非常に薄いカラー（Tint）
	•	テキスト + 斜線アイコン

### ④ Fill Only
	•	枠線なし
	•	背景に濃いカラー
	•	テキストは白のコントラスト色（または適切な色）
	•	アイコンカラーも白系

⸻

## 3. カラーバリエーション（Color Variants）

Chip Label は多数の色カテゴリを持つ：
	•	成功 (Green系)
	•	失敗 (Red系)
	•	注意 (Yellow/Orange系)
	•	情報 (Blue系)
	•	ゴミ分類 (Brown/Beige/Blue/Pink etc.)
	•	プロジェクト状態 (Blue, Green, Orange, Red, Purple etc.)
	•	フェーズ表示（提出済 / 審査中 / 保留中 / 中止 etc.）
	•	ステータス（公開済み / 公開予約 / 下書き etc.）

カラートークンの要件：
	•	Text Only：文字色のみ変わる
	•	Outlined：枠線色 + 文字色
	•	Outlined with Fill：枠線色 + 薄い背景色 + 文字色
	•	Fill Only：濃い背景色 + 白文字

各カラーは DADS のカラートークンに従う必要がある
（例：success-green、info-blue、warning-yellow など）

⸻

## 4. アイコン仕様（必須）

すべての Chip Label には、
左側に “斜線のハッシュアイコン”（DADS標準アイコン） が付く。
	•	色はスタイルに応じて変化
	•	Text Only → テキスト色と同じ
	•	Outlined → テキスト色と同じ
	•	Outlined with Fill → テキスト色
	•	Fill Only → 白 or 背景に対するコントラスト色
	•	大きさは文字サイズ相当（約 12〜14pt）
	•	位置は左側に固定

⸻

## 5. サイズ仕様（Size）

Chip Label のサイズ仕様：
	•	高さ固定（約 24px〜28px 相当）
	•	横幅は可変
	•	左右パディング：8〜12px
	•	角丸：cornerRadius = 999（ピル型）

SwiftUI では以下のように表現できる：

.padding(.horizontal, 8)
.padding(.vertical, 4)
.background(...)
.cornerRadius(999)


⸻

## 6. インタラクション仕様（Interaction）

Chip Label は 非インタラクティブ：
	•	ボタンではない
	•	タップアクションも不要
	•	フォーカスリング不要
	•	hover も適用しない（iOSでは標準なし）

→ 完全に「表示専用コンポーネント」

⸻

## 7. アクセシビリティ要件（A11y）

Chip Label は読取用コンテンツとして扱う：

● VoiceOver 読み上げ例

"承認済み、ステータスラベル"
"作業中、プロジェクト進捗ラベル"

必須要件：
	•	テキストを accessibilityLabel に渡す
	•	色やスタイルは VoiceOver に伝える必要なし（情報過剰）
	•	アイコンは装飾扱いとして読み上げ不要 → .accessibilityHidden(true)

⸻

## 8. コンポーネントの構造（SwiftUI 抽象モデル）

struct ChipLabel {
    let text: String
    let style: ChipLabelStyle       // textOnly / outlined / outlinedFill / fillOnly
    let color: ChipLabelColorToken   // success / error / info / category / status ...
}

例：

ChipLabel(text: "承認済み", style: .outlinedFill, color: .green)


⸻

## 9. 背景色・枠線・文字色のルール

● Text Only

背景	枠線	テキスト
なし	なし	カラートークン色

● Outlined

背景	枠線	テキスト
白	カラートークン色	カラートークン色

● Outlined with Fill

背景（薄い色）	枠線	テキスト
カラーのtint	カラートークン色	カラートークン色

● Fill Only

背景（濃色）	枠線	テキスト
カラートークン濃色	なし	白 or コントラスト色


⸻

## 10. レイアウト（Chip の一覧表示）

提示された画像には
テーブルやタグ一覧での使用例 も含まれる。

必要に応じて：
	•	HStack でタグを1行に並べる
	•	LazyVGridでカラーセットを表示
	•	タグと他の要素（ステータス、タイトル）を組み合わせる

⸻

## 11. 禁則事項（Non-functional）
	•	押下可能にしない（ボタン扱いにしない）
	•	hover スタイルをつけない
	•	ChipTag（操作可能）の UI と混同しない
	•	Iconの形を変更しない（必ず DADS の斜線アイコン）

⸻

# 📌 最終まとめ：Chip Label のコア要件

✔ 表示スタイルは「Text Only / Outlined / Outlined + Fill / Fill Only」の4種類

✔ 左の斜線アイコンは必須（色はスタイルに合わせる）

✔ 成功・失敗・注意・情報など多数のカラーバリエーション

✔ 非インタラクティブ（タップ不可）

✔ ピル型の角丸（cornerRadius = 最大）

✔ 背景・枠線・文字色はカラートークンに合わせて変化

✔ VoiceOver ではテキストのみ読み上げる
