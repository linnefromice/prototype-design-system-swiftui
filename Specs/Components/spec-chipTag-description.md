以下は、提示された画像（Chip Tag コンポーネントの UI と使用例）から抽出した
「チップタグ（Chip Tag）」の機能要件を網羅した Markdown 資料です。

SwiftUI 実装の仕様書として、そのまま利用できるレベルで構成しています。

⸻

# 📘 Chip Tag（チップタグ）— 機能要件（DADS準拠 / SwiftUI向け）

Chip Tag は、ユーザーが 選択済みの条件・タグ・ユーザーなどを表示し、
そのタグを削除可能にする「インタラクティブ」なチップ UI コンポーネント である。

Chip Label（静的チップ）とは異なり、Chip Tag は操作可能コンポーネント。

⸻

## 1. コンポーネント概要

✔ 表示 + 削除ボタン付きの「選択済み項目ラベル」

✔ 操作可能（タップ、フォーカス、削除イベント）

✔ 小さな閉じるボタン（×）を含む

✔ 左に DADS 標準アイコン（斜線セット）を表示

✔ 状態（Default / Hover / Active / Focus）でスタイル変化

⸻

## 2. コンポーネント構成（Structure）

ChipTag は以下の要素で構成される：

+--------------------------------------------------+
| [斜線アイコン]  ラベルテキスト    [閉じる（×）] |
+--------------------------------------------------+

	•	左側アイコン：Chip Label と同じ DADS のハッシュアイコン
	•	中央テキスト：タグ名
	•	右側 × ボタン：削除アクション（ボタン扱い）
	•	ピル型の背景（角丸 999）

⸻

## 3. 状態（States）

Chip Tag は操作 UI なので、4つの状態を持つ：

状態	説明	視覚的変化
Default	通常状態	枠線とテキストはテーマ色
Hover	マウス hover（iPad pointer interaction 用）	背景に薄いテーマ色（tint）
Active	タップ中	枠線 + 背景が濃く強調
Focus	キーボードフォーカス or アクセシビリティフォーカス	黒いフォーカスリングが外側に表示

※Hover は iOS モバイルでは不要、iPadOS Pointer で使用可能。

⸻

## 4. 削除ボタン（×）の仕様

Chip Tag を特徴づける重要要素。

● 役割：
	•	タップで ChipTag を削除する
	•	VoiceOver 上は「削除ボタン」として読まれる必要あり

● UI仕様：
	•	サイズ：Chip 内で収まる小さめの SF Symbol (xmark)
	•	外側に余白（border/padding あり）
	•	状態変化に連動（Hover/Active/Focus 時の強調）

● アクセシビリティ：
	•	accessibilityLabel("〜を削除")
	•	button として認識される

⸻

## 5. 各状態ごとの詳細 UI（Matrix）

提示された画像に基づく状態マトリクス。

State	背景色	枠線	テキスト	アイコン（左）	×ボタン
Default	White	テーマ色（青系 #0056D2）	テーマ色	テーマ色	テーマ色（枠付き）
Hover	薄いテーマ色の背景（Tint）	テーマ色	テキスト = テーマ色	同上	Hover強調
Active	濃い背景	枠線も濃い色	白 or コントラスト色	白 or コントラスト色	白 or コントラスト色
Focus	Default と同じ	黒枠のフォーカスリング（外側）	テーマ色	テーマ色	テーマ色


⸻

## 6. サイズ仕様（Size）
	•	高さ：28〜32px 相当
	•	パディング：
	•	左右：8〜12px
	•	内部要素間間隔：4〜8px
	•	角丸（Corner Radius）：999（ピル型）
	•	アイコンサイズ：12〜14pt
	•	×ボタンサイズ：約 16〜20pt

SwiftUI 例：

.padding(.horizontal, 8)
.padding(.vertical, 4)
.cornerRadius(999)


⸻

## 7. インタラクション要件（Interaction）

✔ Chip 全体はタップ可能

（= 削除ではなく「選択された項目のタップ」などの用途）
ただし多くの場合、タップの主目的は × ボタンのアクション。

✔ × ボタンは独立した tappable 要素
	•	外側ヒットエリアは広めにする（最低44×44pt原則）

✔ Active 状態（押下）は必須

iOSの指針上、タップ中の視覚的変化をつけることが望ましい。

✔ Focus State 対応
	•	アクセシビリティフォーカスでリングが出る
	•	SwiftUI なら .overlay でフォーカスリングを追加

⸻

## 8. アクセシビリティ要件（A11y）

Chip本体
	•	accessibilityLabel("タグ: 〇〇")
	•	選択操作がある場合は Role = button として扱う

×ボタン
	•	"閉じる” / “削除” と読み上げる
	•	ラベル例

accessibilityLabel("\(text) を削除")



グループ化

Chip + ×ボタンはグループとして扱うことが多いが、
DADS の意味上 ×は個別認識が望ましい。

⸻

## 9. 状態遷移（State Machine）

SwiftUI 実装にそのまま使用できる XState 風表記。

states:
  default:
    on:
      HOVER: hover
      ACTIVE: active
      FOCUS: focus

  hover:
    on:
      ACTIVE: active
      BLUR: default
      FOCUS: focus

  active:
    on:
      RELEASE: default
      FOCUS: focus

  focus:
    on:
      BLUR: default
      ACTIVE: active

ポイント：
	•	Disabled 状態は Chip Tag には存在しない
	•	削除完了後はリストから消える

⸻

## 10. 使用例（画像から抽出）

● 検索条件のタグ

現行法令 ×
法令 ×
勅令 ×
関連度順 ×
長いラベル ×

● 宛先のユーザータグ

🧑‍💼 デジ田 太郎 ×
🧑‍💼 デジ演 実 ×

共通要件：
	•	アイコン（ユーザーアイコン）の差し替え可能
	•	長いラベルへの対応（Chip が横に伸びる）
	•	改行は許容（Wrap 表示）

⸻

## 11. コンポーネント API 例（SwiftUI 向け設計）

struct ChipTag {
    let text: String
    let color: ChipTagColor
    let onRemove: () -> Void
    let icon: Image?    // 左アイコン（任意）
}


⸻

## 12. 禁止事項（Non-functional）
	•	Chip Label（静的）と同じスタイルにしない（ChipTag は操作可能）
	•	Hover を iOS スマホで実装しない
	•	× ボタンのヒット領域が小さすぎる実装
	•	背景色と枠線の DADS カラーを無視した最適化

⸻

# 📌 最終まとめ（この UI の本質）

✔ ChipTag は「操作可能コンポーネント」

（Chip Label は非操作）

✔ Default / Hover / Active / Focus の 4 状態が存在

✔ 削除ボタン（×）が必須要素であり、アクセシビリティに対応

✔ アイコン + テキスト + 削除ボタンの固定レイアウト

✔ 色はテーマ色（青）＋濃淡別の背景
