以下では
① テキストエリア（TextArea）コンポーネントの要件整理（UIベース）
② 既存 InputText（単一行 TextField）との差分整理
の 2 つを Markdown 資料として利用できる品質でまとめます。

⸻

# 📘 TextArea（テキストエリア）— 要件整理（DADS準拠）

画像に基づき、TextArea は以下の状態・振る舞い・UI 特性を持つ。

⸻

## 1. 状態（States）

TextArea は以下の 7 状態を持つ：

状態	説明
Default	通常状態
Default : hover	hover（iOS 非対応 → 仕様としては存在するが無視可）
Default : focus	入力中。黒フォーカスリング + 黄色リング
Error	入力が不正。赤枠 + エラーテキスト
Error : hover	hover が乗った状態（iOS不要）
Error : focus	赤枠 + 黒フォーカスリング
Disabled	入力不可（背景グレー、テキスト不可）
Disabled : focus	Disabled のまま黒フォーカスリング（アクセシビリティフォーカス）
Readonly	読み取り専用（薄い枠線 + 背景白）
Readonly : focus	フォーカスリングのみ追加

状態種別は InputText とほぼ共通だが Disabled : focus / Readonly / Readonly : focus が追加されている点が重要。

⸻

## 2. UI 構造（Structure）

+---------------------------------------------+
|  <多行のテキスト入力領域>                    |
+---------------------------------------------+
|      62 / 100                                |

要素構造：
	1.	多行入力フィールド（SwiftUI の TextEditor 相当）
	2.	残り文字数または入力文字数カウンター（右下）
	3.	エラーテキスト（エラー時のみ）
	4.	フォーカスリング（2段階）
	•	内枠：semantic color（黄色）
	•	外枠：黒

⸻

## 3. TextArea の UI 仕様（詳細）

✔ 1. 枠線
	•	Default：薄いグレー（#CCCCCC 相当）
	•	Focus：黄色の太枠 + 黒のフォーカスリング
	•	Error：赤色 error1
	•	Disabled：灰色（solidGray300）
	•	Readonly：点線 or ライトグレー枠（画像より “dotted border”）

✔ 2. 背景
	•	Default：White
	•	Disabled：灰色 (solidGray50)
	•	Readonly：White（変わらず）

✔ 3. テキスト色

状態	テキスト色
Default	solidGray900
Error	solidGray900（ただし下のエラーは赤）
Disabled	solidGray420
Readonly	solidGray900
Placeholder	solidGray420

✔ 4. プレースホルダー
	•	TextEditor には placeholder がないため、Overlay で表示
	•	Disabled の場合は薄いグレーで表示

✔ 5. 文字カウント
	•	右下に 現在文字数 / 最大文字数 を表示
	•	Error 状態では文字数も赤色
	•	Disabled でもカウントは表示される（ただし小さく薄い色）

✔ 6. エラーメッセージ
	•	*エラーテキストが入ります。
	•	error1 の赤
	•	TextField と同じ位置

⸻

## 4. Interaction（ユーザー操作）

操作	TextField	TextArea
単一行入力	✔	✖（必ず複数行）
高さの伸縮	✖	✔ 自動 or 固定
改行入力	✖	✔
スクロール	不要	✔（行数超過時）
文字カウント	オプション	● 必須（DADS仕様）


⸻

## 5. TextField（InputText）との差分まとめ

✔ 1. コアの入力 UI が異なる

Component	基盤コンポーネント
InputText	TextField（単一行）
TextArea	TextEditor（複数行）


⸻

✔ 2. プレースホルダー処理が全く違う

TextEditor には placeholder が無いので、別レイヤーで管理する必要がある。
	•	ZStack(alignment: .topLeading) で placeholder を overlay
	•	入力が空のときのみ表示

⸻

✔ 3. 高さが可変 or 固定

TextEditor は内容に応じてスクロールが必要
→ 高さを固定 or 自動調整（専用 Modifier 必須）

TextField は常に固定高さ 48px 前後。

⸻

✔ 4. 右下の文字カウントが必須

InputText には無いコンポーネント。

TextArea では 編集しながらカウンターを更新する必要がある。

カウントが上限を超えたら Error 状態とも連動。

⸻

✔ 5. Readonly 状態が追加されている

InputText では存在しない UI 状態。

TextArea では：
	•	dotted border（点線）
	•	focus 時の黒リングも可能

⸻

✔ 6. Disabled : focus 状態が存在する

InputText では通常無視されるが
TextArea では「アクセシビリティのフォーカスが入る」前提で状態が存在。

アクセシビリティ対応で必須。

⸻

✔ 7. スクロール挙動の存在

TextEditor は内部でスクロールビューを持つため：
	•	高さ固定時 → 内部スクロール
	•	自動調整する場合 → GeometryReader を併用

InputText にはスクロール概念がない。

⸻

✔ 8. 角丸やフォーカスリングの描画が InputText より複雑

InputText の枠線構造：

背景 fill
通常枠線（1px）
フォーカス枠線（inner）：Yellow
フォーカス枠線（outer）：Black

TextArea の枠線構造はこれと同じ ＋高さが変動する

⸻

## 6. TextArea コンポーネントに必要なパラメータ

struct TextArea {
    @Binding var value: String
    let placeholder: String?
    let maxLength: Int?      // カウント表示に必要
    let isFocused: Bool
    let isDisabled: Bool
    let isReadonly: Bool
    let error: String?
}


⸻

## 7. TextArea 用フォーカスリング仕様

TextField と同じく二重リング：

✔ Focus（Default or Error）
	•	yellow300（太め）→ black（外側）

✔ Error の場合は赤枠が残る（最優先ではない）

描画順序：
	1.	error1 枠（1px）
	2.	yellow 枠（2px）
	3.	black 枠（2px）

⸻

## 8. TextArea 状態マトリクス（UI差分）

状態	枠線	背景	テキスト	カウント	エラー文
Default	gray600	white	黒	gray	なし
Default:focus	yellow + black	white	黒	gray	なし
Error	red	white	黒	red	赤文あり
Error:focus	red + yellow + black	white	黒	red	赤文あり
Disabled	gray300	gray50	gray420	gray	なし
Readonly	dotted(gray600)	white	黒	gray	なし
Readonly:focus	dotted + focusリング	white	黒	gray	なし


⸻

## 9. TextArea の SwiftUI 設計上の注意点

✔ TextEditor は内部パディングが異なるためカスタムが必要

iOS17 以降では .scrollContentBackground(.hidden) が必要。

✔ TextEditor はデフォルトで高さが広がる

最低行数の指定が必要
→ .frame(minHeight: X)

✔ placeholder は overlay で自作

→ 入力が空の時にだけ表示

✔ 右下カウント位置を固定するために overlay or alignmentGuide が必須

⸻

# 🎯 テキストフィールド（InputText）との差分まとめ（要点だけ）

機能	InputText(TextField)	TextArea(TextEditor)
入力行数	1 行固定	複数行
プレースホルダー	TextField 標準	Overlay 必須
右下カウント	✖	● 必須
Readonly 状態	✖	● あり
Disabled:focus	△	● 必須
改行	✖	●
スクロール	✖	●
高さ管理	固定	● 可変
Auto grow	不要	● optional
フォーカスリング	同じ	同じ（だが高さがダイナミック）
枠線	同じ	同じ
Error 表示	同じ	同じ（＋カウントが赤）


⸻

# 📌 まとめ

✔ TextArea は InputText に比べて状態数が多い（Readonly / Disabled:focus）

✔ UI 差分は「複数行入力が前提」「右下カウントが必須」

✔ placeholder を独自実装しなければならない

✔ 高さ調整・内部スクロールの管理が必要

✔ フォーカスリング描画は TextField と同様の二重リングを維持
