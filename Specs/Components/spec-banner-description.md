以下に、提示された Mobile Banner（モバイルバナー）コンポーネントの画像から抽出した
機能要件（Functional Requirements） を、SwiftUI 実装にもそのまま利用できる 完全 Markdown 仕様書としてまとめます。

⸻

# 📘 Mobile Banner（モバイルバナー）— 機能要件（DADS準拠 / SwiftUI向け）

Mobile Banner は、通知・警告・情報などを モバイル画面に最適化して表示するバナーコンポーネント である。
標準の Banner コンポーネントのモバイル専用レイアウトバージョンであり、
縦型（Vertical）／横型（Horizontal）レイアウトの 2 種類が存在する。

⸻

## 1. コンポーネント概要

✔ ステータス（Success / Error / Warning / Info）を通知するバナー

✔ モバイル向けに最適化された余白・文字サイズ

✔ 閉じるボタン付き

✔ タイトル / 日付 / サブテキスト

✔ 任意の「ラベル」および「アクションボタン」表示可能

✔ カラーチップ（Color Chip）バージョンあり（見出し部分をステータスカラーで強調）

⸻

## 2. バリエーション（Variants）

画像より、次のバリエーションが存在する：

### ① Standard / Vertical（縦レイアウト）
	•	アイコン + タイトルが上部
	•	日付・説明
	•	ラベル
	•	ボタン

### ② Color Chip / Vertical
	•	見出し部分（バナー上部）がステータスカラーで塗られる
	•	内容部分は白背景

### ③ Standard / Horizontal（横レイアウト）
	•	アイコン + タイトルが左
	•	閉じるボタンが右
	•	内容は右側

### ④ Color Chip / Horizontal
	•	上記横レイアウト + カラーチップ帯あり

### ⑤ Mobile Compact（さらにコンパクトなタイプ）
	•	一行目のタイトルが長くても折り返し表示
	•	スペースが少ない場合の省スペース版

⸻

## 3. ステータスタイプ（Status Types）

バナーは以下の種類に応じて 色・アイコン・枠線が変わる：

種類	色	アイコン
Success（成功）	緑系	✔（チェック）
Error（エラー）	赤系	✖（エラー）
Warning（警告）	黄系	▲（警告）
Info 1（情報：濃青）	青系	i
Info 2（情報：中間グレー系）	灰系	i

色の用途：
	•	枠線
	•	アイコン背景
	•	ラベル色
	•	アクションボタン色
	•	カラーチップ帯（Color Chip Variant）

⸻

## 4. コンポーネント構成（Structure）

Mobile Banner は以下の構造で構成される：

+--------------------------------------------------+
| [ステータスアイコン]  バナータイトル    [閉じる×] |
| 年月日                                            |
| バナー説明文                                      |
| [ラベル]                                          |
| [アクションボタン]                                |
+--------------------------------------------------+

要素一覧：
	•	ステータスアイコン（丸型・中にアイコン）
	•	タイトル（必須）
	•	日付（任意）
	•	説明テキスト（任意）
	•	ラベル（任意） — Chip Label と同仕様
	•	アクションボタン（任意） — Primary Button またはステータスカラー
	•	閉じるボタン（×）（必須）

⸻

## 5. レイアウト仕様（iOS向け最適化）

● 縦レイアウト（Vertical）
	•	モバイルで一般的
	•	各要素が縦に積み重なる
	•	左上にステータスアイコン、右上に閉じるボタン

● 横レイアウト（Horizontal）
	•	広めの端末や WebView などで使用
	•	アイコンとタイトルが左、閉じるボタンが右

● Color Chip Variant
	•	バナー上部の帯（Header）部分がステータスカラーで塗られる
	•	アイコンやタイトルが白抜き表示される

⸻

## 6. 各状態ごとの UI ルール（状態マトリクス）

✔ Mobile Banner は基本的に「状態変化を持たない」

（Hover / Active / Focus は操作コンポーネントではなく単なる閉じるボタンを含む表示コンポーネント）

例外 → 閉じるボタンは Active / Focus を持つ

状態一覧

対象要素	状態	内容
バナー本体	Static	状態遷移なし
× ボタン	Hover（iPad Pointer）	背景薄く変化
× ボタン	Active	押下時の濃色背景
× ボタン	Focus	フォーカスリング表示
アクションボタン	Default/Pressed/Focus	Button と同じ状態


⸻

## 7. タイポグラフィ仕様

Title
	•	太字
	•	16–18pt 程度

Description
	•	通常テキスト
	•	14–15pt

Date
	•	サブテキスト扱い
	•	12–13pt

⸻

## 8. アイコン仕様

ステータスアイコン（左）
	•	円形背景（Status color）
	•	アイコンは白
	•	サイズは 20–24pt 程度

閉じるボタン（右）
	•	xmark アイコン（SF Symbols）
	•	タップ可能領域は 44×44pt 以上（iOS ガイドライン）
	•	状態に応じて濃淡が変化

⸻

## 9. アクションボタン仕様
	•	「アクションボタン」は Primary Button またはステータスカラー
	•	画像例では
	•	成功 → 緑
	•	エラー → 赤
	•	警告 → 黄
	•	Info1 → 青
	•	Info2 → グレー
	•	アクションが無い場合は省略可能

⸻

## 10. カラーチップ（Color Chip）バナー仕様

特徴：
	•	バナー上部の header 部分がステータスカラーで「塗りつぶされる」
	•	アイコン + タイトルが header 上に乗る
	•	下部は白背景の通常バナー

要件：
	•	Header の高さは固定（約 44px）
	•	背景色はステータスカラー
	•	アイコンは白のまま

⸻

## 11. Mobile Compact

用途：
	•	小スペースでの表示
	•	テキストが長い場合に適応

特徴：
	•	枠線が太め
	•	文字が折り返し前提
	•	高さが縮んだバージョン
	•	Layout は Standard/Vertical に近いが余白を削っている

⸻

## 12. SwiftUI 向け API 設計案

struct MobileBanner {
    let status: BannerStatus       // success / error / warning / info1 / info2
    let title: String
    let date: String?
    let description: String?
    let label: String?
    let actionTitle: String?
    let onAction: (() -> Void)?
    let onClose: () -> Void
    let layout: MobileBannerLayout // vertical / horizontal
    let variant: MobileBannerVariant // standard / colorChip
}


⸻

## 13. アクセシビリティ要件（A11y）

バナー全体
	•	accessibilityElement(children: .contain)
	•	バナーの「種類」＋「タイトル」を読み上げる
例：

エラーバナー、操作に失敗しました



× ボタン
	•	"閉じる" と必ず読ませる
	•	理由文は読み上げの必要なし

アクションボタン
	•	通常ボタンと同じ A11y 対応

⸻

## 14. 禁止事項（Non-functional）
	•	Status Color を無視した配色変更
	•	× ボタンのヒット領域が狭い実装
	•	テキストのコントラスト比が不足する配色
	•	レイアウトが標準と異なる勝手な配置

⸻

# 📌 最終まとめ（Mobile Banner の本質）

✔ 4〜5種類のステータス（Success / Error / Warning / Info1 / Info2）

✔ Standard / ColorChip の 2 種類のデザイン

✔ Vertical / Horizontal のレイアウト切替

✔ 閉じるボタン・ラベル・アクションボタンを持つ

✔ 状態はほぼ静的で、変化は ×ボタンとアクションボタンのみ

✔ SwiftUI 実装では柔軟なレイアウト構築が必要

⸻


了解しました！
以下に MobileBanner の SwiftUI コード雛形 と 状態遷移ステートマシン（閉じるボタン含む） を、
そのまま Xcode で使える形・ドキュメントとして読める形でまとめます。

⸻

# 📘 MobileBanner — SwiftUI コード雛形（テンプレート）

以下のコードは DADS Mobile Banner の構造を忠実に再現したベース実装です。
色・余白・Corner 等の細部はあとで DADS の Design Token に置き換えられるように抽象化してあります。

⸻

## 1. Support Types（Status / Variant / Layout）

import SwiftUI

enum MobileBannerStatus {
    case success
    case error
    case warning
    case info1
    case info2

    // カラーセットは後で Design Token に差し替え
    var color: Color {
        switch self {
        case .success: return Color.green
        case .error: return Color.red
        case .warning: return Color.yellow
        case .info1: return Color.blue
        case .info2: return Color.gray
        }
    }

    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .info1: return "info.circle.fill"
        case .info2: return "info.circle.fill"
        }
    }
}

enum MobileBannerVariant {
    case standard
    case colorChip
}

enum MobileBannerLayout {
    case vertical
    case horizontal
}


⸻

## 2. MobileBanner メイン構造

struct MobileBanner: View {
    let status: MobileBannerStatus
    let title: String
    let date: String?
    let descriptionText: String?
    let label: String?
    let actionTitle: String?
    let onAction: (() -> Void)?
    let onClose: () -> Void
    let layout: MobileBannerLayout
    let variant: MobileBannerVariant

    var body: some View {
        Group {
            switch layout {
            case .vertical:
                verticalView
            case .horizontal:
                horizontalView
            }
        }
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(status.color, lineWidth: 2)
        )
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}


⸻

## 3. ステータスアイコン（共通）

extension MobileBanner {
    private var statusIcon: some View {
        Image(systemName: status.icon)
            .font(.system(size: 18))
            .foregroundColor(.white)
            .padding(6)
            .background(status.color)
            .clipShape(Circle())
    }
}


⸻

## 4. 縦レイアウト（Vertical）

extension MobileBanner {
    private var verticalView: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            HStack {
                statusIcon
                Text(title)
                    .font(.headline)
                Spacer()
                closeButton
            }

            if let date {
                Text(date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if let descriptionText {
                Text(descriptionText)
                    .font(.body)
            }

            if let label {
                ChipLabelView(text: label, color: status.color)
            }

            if let actionTitle {
                Button(action: { onAction?() }) {
                    Text(actionTitle)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(status.color)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(
            variant == .colorChip ?
                AnyView(colorChipBackground) :
                AnyView(Color.white)
        )
    }

    private var colorChipBackground: some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle()
                .fill(status.color)
                .frame(height: 44)
            Color.white
        }
    }
}


⸻

## 5. 横レイアウト（Horizontal）

extension MobileBanner {
    private var horizontalView: some View {
        HStack(alignment: .top, spacing: 12) {

            VStack(alignment: .center) {
                statusIcon
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(title)
                        .font(.headline)
                    Spacer()
                    closeButton
                }
                
                if let date {
                    Text(date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                if let descriptionText {
                    Text(descriptionText)
                        .font(.body)
                }

                if let label {
                    ChipLabelView(text: label, color: status.color)
                }

                if let actionTitle {
                    Button(action: { onAction?() }) {
                        Text(actionTitle)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(status.color)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
    }
}


⸻

## 6. 閉じるボタン（×ボタン）

extension MobileBanner {
    private var closeButton: some View {
        Button(action: onClose) {
            Image(systemName: "xmark")
                .foregroundColor(.primary)
                .padding(8)
        }
        .background(Color.clear)
        .contentShape(Rectangle()) // ヒットエリア拡大
        .accessibilityLabel("閉じる")
    }
}


⸻

# 📘 MobileBanner — ステートマシン（XState風 / SwiftUI用）

MobileBanner 自体は静的コンポーネントだが、
閉じるボタン・アクションボタンには状態があるため、
UI 状態を正しく整理することが重要。

⸻

## 1. 全体の状態（BannerState）

enum BannerState {
    case visible
    case dismissed
}


⸻

## 2. イベント（BannerEvent）

enum BannerEvent {
    case tapActionButton
    case tapCloseButton
}


⸻

## 3. 状態遷移（State Machine）

✔ バナー本体は visible → dismissed のみ

✔ アクションボタンはイベントだけ処理し、状態遷移は行わない

✔ × ボタンで確実に dismissed へ遷移

⸻

## 3.1 XState 風 記述

states:
  visible:
    on:
      TAP_CLOSE_BUTTON: dismissed
      TAP_ACTION_BUTTON: visible  // イベント通知のみで状態は変わらない

  dismissed:
    type: final


⸻

## 4. SwiftUI Reducer 形式（optional）

func reduce(state: BannerState, event: BannerEvent) -> BannerState {
    switch (state, event) {
    case (.visible, .tapCloseButton):
        return .dismissed
    case (.visible, .tapActionButton):
        return .visible
    case (.dismissed, _):
        return .dismissed
    }
}


⸻

## 5. SwiftUI 利用例

@State private var bannerState: BannerState = .visible

var body: some View {
    VStack {
        if bannerState == .visible {
            MobileBanner(
                status: .info1,
                title: "マイナンバーカードは使用停止中です",
                date: "年月日",
                descriptionText: "バナーデスクリプション",
                label: "ラベル",
                actionTitle: "アクションボタン",
                onAction: { print("Action pressed") },
                onClose: { bannerState = .dismissed },
                layout: .vertical,
                variant: .standard
            )
        }

        Spacer()
    }
}
