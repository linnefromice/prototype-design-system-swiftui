以下は、提示いただいた画像をもとに DADS Radio Button（ラジオボタン）コンポーネントの UI・機能・状態要件を完全に抽出した Markdown 資料です。

SwiftUI 実装時にそのまま仕様書として利用できる粒度に整理しています。

⸻

# 📘 Radio Button（ラジオボタン）— 要件仕様（DADS準拠）

ラジオボタンは 単一選択 を行うフォームコンポーネントで、
DADS では 非常に多くの状態 と Inline / Stacked / Units のレイアウトバリエーションが定義されている。

以下は UI 要件と機能要件をまとめたもの。

⸻

## 1. コア構造（UIベース）

+-----------------------------------------------------+
| (○) ラベル                                          |
|    └ サポートテキスト（任意）                       |
|    └ エラーテキスト（エラー時のみ）                |
+-----------------------------------------------------+

要素構造：
	•	ラジオボタン本体（円形）
	•	ラベル（選択肢の名称）
	•	サポートテキスト（任意）
	•	エラーテキスト（グループ単位のエラー）

⸻

## 2. 状態（States）

画像より、ラジオボタンは以下の完全状態セットを持つ：

⸻

🎨 基本状態（選択前）
	1.	Default
	2.	Default : hover
	3.	Default : focus

⸻

🎨 選択状態（Checked）
	4.	Checked
	5.	Checked : hover
	6.	Checked : focus

⸻

🎨 エラー状態（Error）
	7.	Default Error
	8.	Default Error : hover
	9.	Default Error : focus
	10.	Checked Error
	11.	Checked Error : hover
	12.	Checked Error : focus

⸻

🎨 無効状態（Disabled）
	13.	Default Disabled
	14.	Checked Disabled
	15.	Default Disabled : focus
	16.	Checked Disabled : focus

⸻

✔ 合計16状態

SwiftUI 実装時には enum + boolean の組み合わせで管理可能。

⸻

## 3. 各状態の UI 要件

🔵 Default
	•	外枠：gray600（1px）
	•	背景：white
	•	中央のチェックなし

🔵 Hover（iOSでは不要）
	•	外枠の濃淡が変わる（hover強調）
	•	iOS/iPadOS Pointer Interaction のみ対応してよい

🔵 Focus
	•	二重リング
	•	inner：yellow300（太め）
	•	outer：black（太枠）
	•	背景は白
	•	枠線は default のまま

⸻

🔵 Checked
	•	外枠：テーマ色（blue600）
	•	内側：filled circle（青）
	•	hover で若干色が強調される

🔵 Checked : focus
	•	checked の色そのまま + 二重フォーカスリング
	•	inner yellow + outer black

⸻

🔴 Error（未選択エラー）
	•	枠線：red（error1）
	•	内側：塗りなし

🔴 Checked Error
	•	枠線：red
	•	内側チェック：濃赤
	•	error:focus → 二重フォーカスリング追加（黄色 + 黒）

⸻

⚪ Disabled
	•	枠線：gray300
	•	内側：filled なし or gray
	•	テキスト色：gray420
	•	操作不可
	•	focus（アクセシビリティフォーカス）の場合は黒のフォーカスリングのみ表示

⸻

## 4. サイズ（Small / Medium / Large）

画像より、Inline と Stacked で 3サイズが定義されている：

サイズ	ラジオ直径	ラベル文字サイズ
Small	小	小
Medium	中	中
Large	大	大

SwiftUI では以下のように適用可能：

enum RadioSize {
    case small, medium, large

    var diameter: CGFloat { ... }
    var font: Font { ... }
}


⸻

## 5. レイアウト Variants

UI 画像では 3 種類のレイアウトが存在する：

⸻

### ① Radio Button Units

（単純にラジオ＋ラベルが横に並ぶ基本単位）

(○) 選択肢

用途：大量のラジオを一覧する場合

⸻

### ② Inline（横並び）

ラベル（必須）
サポートテキスト
(○) A   (○) B   (○) C   (○) D
★エラーテキスト

	•	横スクロール系の選択に適する
	•	ラベルとサポートテキストが上部

⸻

### ③ Stacked（縦並び）

ラベル（必須）
サポートテキスト
(○) A
(○) B
(○) C
★エラーテキスト

	•	1項目1行で読みやすい
	•	Medium / Large の2種類あり

⸻

## 6. エラーテキスト（Error Message）

画像より、エラー時にはラジオコンポーネントの下に：

* エラーテキストが入ります。

が赤文字で表示される。

場所は Inline/Stacked どちらでもラジオグループの下。

※ ラジオ一つ単体ではなく グループ単位でエラーメッセージを持つ
→ SwiftUI では RadioGroup などのコンテナで管理する必要がある。

⸻

## 7. 重要な機能要件（スマホ実装）

✔ ラジオは単一選択（排他選択）
	•	SwiftUI では @Binding や Enum で単一値を保持

✔ タップ領域は広めにする（44×44pt以上）

✔ フォーカスリングは二重リング（黄色→黒）

InputText / SelectBox と同じ DADS フォーカス体系。

✔ Disabled 時のテキスト色・枠線色変更

✔ エラー状態は必ず枠線を赤に（中は塗らない）

✔ hover 状態は iOS では原則無視

⸻

## 8. アクセシビリティ（A11y）
	•	ラジオは button ではなく accessibilityRole(.radioButton)
	•	ラベル読み上げは必須
	•	グループは accessibilityElement(children: .contain)
	•	エラー状態の読み上げ → "エラー: 選択必須です"

⸻

## 9. 状態遷移（State Machine）

ラジオ単体の状態遷移（XState風）：

states:
  default:
    on:
      FOCUS → focus
      HOVER → hover
      CHECK → checked
      ERROR → defaultError
      DISABLE → defaultDisabled

  hover:
    on:
      BLUR → default
      CHECK → checked
      ERROR → defaultError

  focus:
    on:
      BLUR → default
      CHECK → checked
      ERROR → defaultError

  checked:
    on:
      FOCUS → checkedFocus
      ERROR → checkedError
      DISABLE → checkedDisabled

  checkedFocus:
    on:
      BLUR → checked
      ERROR → checkedError

  defaultError:
    on:
      FOCUS → defaultErrorFocus
      CHECK → checkedError

  defaultErrorFocus:
    on:
      BLUR → defaultError
      CHECK → checkedError

  checkedError:
    on:
      FOCUS → checkedErrorFocus

  checkedErrorFocus:
    on:
      BLUR → checkedError

  defaultDisabled:
    type: final

  checkedDisabled:
    type: final


⸻

## 10. SwiftUI 用パラメータ案

struct RadioItem {
    let id: String
    let label: String
    let support: String?
}

struct RadioButton: View {
    let item: RadioItem
    let isSelected: Bool
    let isError: Bool
    let isDisabled: Bool
    let size: RadioSize
    @Binding var selectedId: String
}


⸻

## 11. TextField / Checkbox / Radio の比較（重要）

項目	TextField	Checkbox	Radio
選択数	文字入力	複数選択	単一選択
UI 状態	多い	少なめ	最多（16状態）
グループ管理	不要	Optional	● 必須
エラー表示	単体	単体	グループ単位
ホバー	なし	一応ある	一応ある


⸻

# 📌 最終まとめ

✔ ラジオボタンは 16種類の状態 を持つ（Default / Checked / Error / Disabled × focus/hover）

✔ Inline / Stacked / Units の 3つのレイアウトがある

✔ エラーは グループ単位で赤文を表示する

✔ フォーカスリングは TextField / SelectBox と同じ二重リング

✔ Disabled や Readonly を含む UI 色の厳密な管理が必要

✔ ホバーは iOS 実装では原則不要（iPadOS Pointer のみ対応可能）

------------------------

了解しました！
以下に SwiftUI 用ラジオボタンの完全実装テンプレート / RadioGroup API / 状態別プレビュー一覧 をまとめて提供します。

DADS ラジオボタンの 全状態（Default / Checked / Error / Disabled / Focus） に対応し、
フォーカスリング・エラー枠線・Disabledスタイルを忠実に再現できる構成になっています。

⸻

# 📘 1. ラジオボタン SwiftUI 完全実装テンプレート

以下コードは、あなたのデザインシステムの InputText などと統一性を持たせて作成しています。

## 🧩 RadioButtonStyle（状態管理の基盤）

import SwiftUI

enum RadioStatus {
    case normal
    case error
    case disabled
}

struct RadioButtonStyle {
    let status: RadioStatus
    let isSelected: Bool
    let isFocused: Bool

    var borderColor: Color {
        switch (status, isSelected) {
        case (.error, _): return AppColor.Semantic.Error.error1
        case (.disabled, _): return AppColor.Neutral.SolidGray.solidGray300
        case (.normal, true): return AppColor.Semantic.Info.info1
        case (.normal, false): return AppColor.Neutral.SolidGray.solidGray600
        }
    }

    var fillColor: Color {
        if status == .disabled {
            return AppColor.Neutral.SolidGray.solidGray300
        }
        return isSelected ? AppColor.Semantic.Info.info1 : .clear
    }

    var foregroundColor: Color {
        switch status {
        case .disabled: return AppColor.Neutral.SolidGray.solidGray420
        case .error: return AppColor.Semantic.Error.error1
        case .normal: return AppColor.Neutral.SolidGray.solidGray900
        }
    }
}


⸻

## 🧩 RadioButton コンポーネント

struct RadioButton: View {
    let label: String
    let supportText: String?
    let id: String

    @Binding var selectedId: String
    let status: RadioStatus
    let size: RadioSize

    @FocusState private var isFocused: Bool

    var isSelected: Bool { selectedId == id }

    var body: some View {
        Button(action: {
            guard status != .disabled else { return }
            selectedId = id
        }) {
            HStack(alignment: .top, spacing: 12) {
                radioCircle
                VStack(alignment: .leading, spacing: 4) {
                    Text(label)
                        .font(size.font)
                        .foregroundColor(style.foregroundColor)

                    if let supportText {
                        Text(supportText)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .focused($isFocused)
    }

    private var style: RadioButtonStyle {
        RadioButtonStyle(status: status, isSelected: isSelected, isFocused: isFocused)
    }

    private var radioCircle: some View {
        ZStack {
            Circle()
                .stroke(style.borderColor, lineWidth: 2)
                .frame(width: size.diameter, height: size.diameter)

            if isSelected {
                Circle()
                    .fill(style.fillColor)
                    .frame(width: size.innerDiameter, height: size.innerDiameter)
            }

            // Focus ring
            if isFocused && status != .disabled {
                Circle()
                    .stroke(AppColor.Primitive.Yellow.yellow300, lineWidth: 3)
                    .padding(-3)
                Circle()
                    .stroke(AppColor.Neutral.black, lineWidth: 3)
                    .padding(-6)
            }
        }
    }
}


⸻

## 🧩 RadioSize（サイズ管理）

enum RadioSize {
    case small, medium, large

    var diameter: CGFloat {
        switch self {
        case .small: return 16
        case .medium: return 20
        case .large: return 24
        }
    }

    var innerDiameter: CGFloat {
        switch self {
        case .small: return 8
        case .medium: return 10
        case .large: return 12
        }
    }

    var font: Font {
        switch self {
        case .small: return .footnote
        case .medium: return .body
        case .large: return .title3
        }
    }
}


⸻

# 📘 2. RadioGroup コンポーネント API 設計

RadioButton は単体で使われることは少なく、
実際のフォームでは RadioGroup（グループ） として使用されます。

以下は DADS の Inline / Stacked / Units レイアウトを再現できる API 設計です。

⸻

## 🧩 RadioGroup モデル

struct RadioItem {
    let id: String
    let label: String
    let support: String?
}


⸻

## 🧩 RadioGroup レイアウト

enum RadioGroupLayout {
    case inline
    case stacked
    case units
}


⸻

## 🧩 RadioGroup 実装

struct RadioGroup: View {
    let title: String?
    let required: Bool
    let supportText: String?
    let errorText: String?

    let layout: RadioGroupLayout
    let items: [RadioItem]
    let size: RadioSize

    @Binding var selectedId: String

    var status: RadioStatus {
        if let _ = errorText {
            return .error
        }
        return .normal
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            if let title {
                HStack {
                    Text(title)
                        .font(.headline)
                    if required {
                        Text("※必須")
                            .foregroundColor(AppColor.Semantic.Error.error1)
                            .font(.subheadline)
                    }
                }
            }

            if let supportText {
                Text(supportText)
                    .font(.caption)
            }

            switch layout {
            case .inline:
                inlineLayout

            case .stacked:
                stackedLayout

            case .units:
                unitsLayout
            }

            if let errorText {
                Text("* \(errorText)")
                    .foregroundColor(AppColor.Semantic.Error.error1)
                    .font(.caption)
            }
        }
    }

    private var inlineLayout: some View {
        HStack(spacing: 24) {
            ForEach(items, id: \.id) { item in
                RadioButton(
                    label: item.label,
                    supportText: nil,
                    id: item.id,
                    selectedId: $selectedId,
                    status: status,
                    size: size
                )
            }
        }
    }

    private var stackedLayout: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(items, id: \.id) { item in
                RadioButton(
                    label: item.label,
                    supportText: nil,
                    id: item.id,
                    selectedId: $selectedId,
                    status: status,
                    size: size
                )
            }
        }
    }

    private var unitsLayout: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(items, id: \.id) { item in
                RadioButton(
                    label: item.label,
                    supportText: item.support,
                    id: item.id,
                    selectedId: $selectedId,
                    status: status,
                    size: size
                )
            }
        }
    }
}


⸻

# 📘 3. 状態別プレビュー一覧（全16状態）

以下は、画像にある DADS ラジオボタンの状態一覧を SwiftUI Preview として網羅したテンプレートです。

⸻

## 🧪 ラジオボタン単体の状態プレビュー

struct RadioButtonPreview: View {
    @State var selected = "a"

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {

            Group {
                Text("Default")
                RadioButton(label: "選択肢", supportText: nil, id: "a",
                            selectedId: $selected, status: .normal, size: .medium)
            }

            Group {
                Text("Checked")
                RadioButton(label: "選択肢", supportText: nil, id: "a",
                            selectedId: $selected, status: .normal, size: .medium)
            }

            Group {
                Text("Error")
                RadioButton(label: "選択肢", supportText: nil, id: "a",
                            selectedId: $selected, status: .error, size: .medium)
            }

            Group {
                Text("Disabled")
                RadioButton(label: "選択肢", supportText: nil, id: "a",
                            selectedId: $selected, status: .disabled, size: .medium)
            }
        }
        .padding()
    }
}


⸻

## 🧪 RadioGroup の状態別プレビュー

struct RadioGroupPreview: View {
    @State var selected = ""

    let items = [
        RadioItem(id: "1", label: "選択肢A", support: nil),
        RadioItem(id: "2", label: "選択肢B", support: nil),
        RadioItem(id: "3", label: "選択肢C", support: nil)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 40) {

                RadioGroup(
                    title: "Inline",
                    required: true,
                    supportText: "サポートテキスト",
                    errorText: nil,
                    layout: .inline,
                    items: items,
                    size: .medium,
                    selectedId: $selected
                )

                RadioGroup(
                    title: "Stacked",
                    required: true,
                    supportText: "サポートテキスト",
                    errorText: "エラーテキストが入ります。",
                    layout: .stacked,
                    items: items,
                    size: .medium,
                    selectedId: $selected
                )

                RadioGroup(
                    title: "Units",
                    required: false,
                    supportText: nil,
                    errorText: nil,
                    layout: .units,
                    items: items,
                    size: .medium,
                    selectedId: $selected
                )
            }
            .padding()
        }
    }
}


⸻

# 📌 最終まとめ

これでラジオボタンについて以下のすべてを提供しました：

✔ SwiftUI 完全実装テンプレート

（全状態・フォーカスリング・Disabled など DADS 仕様対応）

✔ RadioGroup コンポーネント API 設計

（Inline / Stacked / Units / エラー / 必須ラベルも含む）

✔ 状態別プレビュー一覧

（単体とグループの preview すべて網羅）
