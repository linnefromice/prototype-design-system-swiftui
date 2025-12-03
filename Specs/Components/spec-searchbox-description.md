了解しました！
以下に、提示された画像をもとにした DADS「Search Box（検索ボックス）」の要件定義（左側の検索対象 UI 部分含む） を、SwiftUI 実装仕様としてそのまま利用できるレベルで整理します。

⸻

# 📘 Search Box（検索ボックス）— 要件整理（DADS準拠）

画像から読み取れる Search Box は、DADS における「検索入力 UI」の統合コンポーネントで、
以下の UI 要素を含む複合構造になっている：

┌──────────────────────────────────────────┐  ┌───────────┐
│  [検索対象セレクト]  [検索アイコン]  [テキスト入力] │  │検索ボタン│
└──────────────────────────────────────────┘  └───────────┘


⸻

# 1. 構成要素（Structure）

✔ ① 左側：検索対象セレクト（ミニセレクトボックス）
	•	「検索対象：すべて」「人物」「法令」などを切り替える UI
	•	下矢印アイコン（▼）が右側に表示される
	•	2行テキストが可能（例：検索対象 / すべて）
	•	枠線で囲まれている（SearchField と一体風に見える）

※ 機能実装は後回しでよく、UI 部分のみ考慮すればよいとのことなので
ここでは UI 部分として定義します。

⸻

✔ ② 真ん中：検索入力フィールド
	•	検索アイコン（虫眼鏡）が左側に表示される
	•	Placeholder は薄いグレー
	•	枠線は丸角8pxの外枠
	•	内側パディングは左右 16pt 程度
	•	isFocused の時はフォーカスリング（黄色→黒の二重リング）

⸻

✔ ③ 右側：検索ボタン
	•	Semantic.Info (青) の塗りボタン
	•	高さはおそらく 40〜44pt
	•	角丸は 8pt
	•	白文字で「検索」

⸻

# 2. レイアウト要件（Layout）

全体は以下の 2要素で構成される：

[検索対象 + 検索入力のコンテナ]   [検索ボタン]

間に 8〜12pt の水平スペースがある。

検索対象 + 入力欄は1つの大きな枠線で繋がれているように見える：

┌───────────────┬──────────────────────────────┐
│  Select Box   │     TextField + Icon          │
└───────────────┴──────────────────────────────┘

✔ 左右の枠線は連結されている
	•	真ん中に区切り線（vertical divider）

⸻

# 3. 状態（States）

検索ボックスは以下の状態を持つ：

状態	対象	内容
Default	全体	薄い灰色枠線
Hover	※iOSでは不要	PC版向け
Focus	TextField部	黄色 + 黒の二重リング（DADS準拠）
Disabled	全体	灰色背景＋灰色テキスト
Error	TextField部	赤枠・エラーテキスト（DADS入力と共通）

※ 画像には Error が明確には表示されていないが、DADS の Input 要件から必ず存在する。

⸻

# 4. 各 UI コンポーネント要件

⸻

## A. 検索対象セレクト（Filter Selector）

✔ UI 要件
	•	高さは TextField と揃える（40〜44pt）
	•	角丸は左側だけ（右側はフラット）
	•	内部テキストは上下に2行（例：検索対象 / すべて）
	•	右側に小さな下向き矢印
	•	区切り線は gray300

✔ 枠線

全体枠の一部として扱う
→ セレクト部分だけ独立した枠ではない（見た目は一体）

✔ Placeholder は不要

（常に選択肢が表示されるため）

⸻

## B. TextField（検索入力欄）

✔ 左にアイコン（虫眼鏡）
	•	SF Symbol は "magnifyingglass"
	•	色は neutral gray 500 付近

✔ Placeholder
	•	DADS の placeholder と同じライトグレー（solidGray420）
	•	左にアイコンがあるためアイコンの右にテキストを置く

✔ 入力時の状態変化

状態	枠線	背景
Default	gray600	white
Focus	yellow300 + black（2重）	white
Disabled	gray300	gray50
Error	red	white

※ InputText と完全に一致させる

⸻

## C. 検索ボタン

✔ UI 要件
	•	Semantic.Info の青色塗り（#0053D9系）
	•	CornerRadius = 8
	•	Padding は上下12、左右16程度
	•	テキストは白、Medium ウェイト

✔ 状態
	•	Disabled（灰色）
	•	Pressed（少し暗い青）
	•	Active（iOS標準の押下状態）

⸻

# 5. コンポーネント仕様（SwiftUI構造）

推奨コンポーネント構造：

SearchBox
 ├─ SearchScopeSelector（← UIのみでOK）
 ├─ SearchField（InputTextに近い）
 └─ SearchButton（Button）


⸻

### A. SearchScopeSelector（UIのみ）

struct SearchScopeSelector: View {
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption2)
                    .foregroundColor(AppColor.Neutral.SolidGray.solidGray600)
                Text(value)
                    .font(.body)
                    .foregroundColor(AppColor.Neutral.SolidGray.solidGray900)
            }

            Image(systemName: "chevron.down")
                .foregroundColor(AppColor.Neutral.SolidGray.solidGray600)
        }
        .padding(.horizontal, 12)
        .frame(height: 44)
    }
}


⸻

### B. SearchField（TextField + Icon）

InputText のロジックを流用可：
	•	アイコン追加
	•	左パディング調整
	•	枠線が全体で1本に見えるよう調整

⸻

### C. SearchButton

ButtonStyle を再利用：

Button("検索", action: onSearch)
    .buttonStyle(PrimaryButtonStyle())


⸻

# 6. SearchBox の全体構造（SwiftUI）

struct SearchBox: View {
    @State var query: String = ""
    let scopeLabel: String
    let scopeValue: String
    let onSearch: () -> Void

    var body: some View {
        HStack(spacing: 12) {

            HStack(spacing: 0) {
                SearchScopeSelector(title: scopeLabel, value: scopeValue)

                Divider()
                    .frame(width: 1)
                    .background(AppColor.Neutral.SolidGray.solidGray300)

                SearchInputField(text: $query)
            }
            .overlay(searchBoxBorder)

            Button("検索", action: onSearch)
                .buttonStyle(PrimaryButtonStyle())
        }
    }

    private var searchBoxBorder: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(AppColor.Neutral.SolidGray.solidGray600, lineWidth: 1)
    }
}

※ フォーカス時は二重リングに差し替え。

⸻

# 7. 検索ボックスの重要ポイントまとめ

✔ 検索対象セレクトは「セレクトボックスの縮小版」

✔ 右側の検索ボタンは同システムの PrimaryButton と同仕様

✔ 中央の検索フィールドは InputText とほぼ同一仕様

✔ 全体枠は1本で、内部は Divider で区切る

✔ ラベルは 2行構成（検索対象 / すべて）

✔ アイコン付きの TextField（magnifyingglass）

✔ フォーカス時の二重リングは DADS 共通仕様

了解しました！
以下に SearchBox の完全 SwiftUI 実装コードと
FocusState・フォーカスリング（DADS二重リング）対応版を
そのまま Xcode で動くレベルで提供します。

⸻

# 📘 完全版 SearchBox（SwiftUI 実装）

以下のコンポーネントを含みます：
	•	SearchBox（親）
	•	SearchScopeSelector（左セレクト UI）
	•	SearchTextField（右側テキスト入力 + 検索アイコン）
	•	DADS フォーカスリング対応（黄 + 黒）
	•	Error / Disabled にも拡張しやすい構造

すべて DADS の InputText / SelectBox と同じデザインルールで統一しています。

⸻

# 1. SearchBox（親コンポーネント）

import SwiftUI

public struct SearchBox: View {
    @Binding var query: String
    let scopeLabel: String
    let scopeValue: String
    let placeholder: String
    let onSearch: () -> Void

    @FocusState private var isFocused: Bool

    public init(
        query: Binding<String>,
        scopeLabel: String = "検索対象",
        scopeValue: String = "すべて",
        placeholder: String = "キーワードを入力",
        onSearch: @escaping () -> Void
    ) {
        self._query = query
        self.scopeLabel = scopeLabel
        self.scopeValue = scopeValue
        self.placeholder = placeholder
        self.onSearch = onSearch
    }

    public var body: some View {
        HStack(spacing: 12) {

            // ▼ 左側 + TextField 全体コンテナ
            HStack(spacing: 0) {
                SearchScopeSelector(label: scopeLabel,
                                    value: scopeValue)

                Divider()
                    .frame(width: 1, height: 44)
                    .background(AppColor.Neutral.SolidGray.solidGray300)

                SearchTextField(
                    query: $query,
                    placeholder: placeholder,
                    isFocused: isFocused
                )
                .focused($isFocused) // ← focus binding
            }
            .background(
                ZStack {
                    baseBorder
                    if isFocused {
                        focusRing
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))

            // ▼ 検索ボタン
            Button("検索") { onSearch() }
                .buttonStyle(PrimaryButtonStyle())
        }
        .padding(.horizontal)
    }
}


⸻

# 2. SearchScopeSelector（左セレクト風 UI）

UI 部分のみの実装（今回要求通り、機能は後で追加可）です。

struct SearchScopeSelector: View {
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption2)
                    .foregroundColor(AppColor.Neutral.SolidGray.solidGray600)
                Text(value)
                    .font(.body)
                    .foregroundColor(AppColor.Neutral.SolidGray.solidGray900)
            }

            Image(systemName: "chevron.down")
                .foregroundColor(AppColor.Neutral.SolidGray.solidGray600)
                .font(.caption)
        }
        .padding(.horizontal, 12)
        .frame(height: 44)
    }
}


⸻

# 3. SearchTextField（右側のテキスト入力部）

InputText コンポーネントと同じ枠線ルールに準拠。

struct SearchTextField: View {
    @Binding var query: String
    let placeholder: String
    let isFocused: Bool

    var body: some View {
        HStack(spacing: 8) {

            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColor.Neutral.SolidGray.solidGray600)

            TextField("", text: $query)
                .foregroundColor(AppColor.Neutral.SolidGray.solidGray900)
                .placeholder(when: query.isEmpty) {
                    Text(placeholder)
                        .foregroundColor(AppColor.Neutral.SolidGray.solidGray420)
                }
        }
        .padding(.horizontal, 12)
        .frame(height: 44)
    }
}


⸻

# 4. 枠線（Base Border / Focus Ring）

DADS のフォーカスリングは 「黄 → 黒」二重リングです
（InputText と SelectBox の既存仕様と統一）。

extension SearchBox {
    /// 通常時の外枠（gray）
    private var baseBorder: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(
                AppColor.Neutral.SolidGray.solidGray600,
                lineWidth: 1
            )
    }

    /// フォーカスリング（黄 → 黒 の 2段）
    private var focusRing: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(AppColor.Primitive.Yellow.yellow300, lineWidth: 2)
                .padding(-2)

            RoundedRectangle(cornerRadius: 8)
                .stroke(AppColor.Neutral.black, lineWidth: 2)
                .padding(-4)
        }
    }
}


⸻

# 5. プレースホルダー用 Modifier

TextField の placeholder カスタムを再利用可能にする Modifier。

extension View {
    @ViewBuilder
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            if shouldShow { placeholder() }
            self
        }
    }
}


⸻

# 6. 使用例（Preview）

struct SearchBox_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 40) {
            SearchBox(
                query: .constant(""),
                scopeLabel: "検索対象",
                scopeValue: "すべて",
                placeholder: "キーワードを入力",
                onSearch: { print("検索") }
            )

            SearchBox(
                query: .constant("SwiftUI"),
                scopeLabel: "検索対象",
                scopeValue: "コンポーネント",
                onSearch: {}
            )
        }
        .padding()
    }
}

⸻

# 📌 SearchBox の焦点ポイント（DADS準拠）

✔ 左側 UI（ScopeSelector）はセレクトボックスのミニ版

✔ TextField のフォーカスリングは InputText / SelectBox と同じ

✔ 内部区切り線（Divider）は gray300

✔ 外側枠線は 1本

✔ ボタンはシステムの PrimaryButtonStyle を流用

✔ Hover は iOS では不要

✔ Disabled / Error の拡張も容易
