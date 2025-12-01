import SwiftUI

// MARK: - Enums

public enum ChipTagState: CaseIterable {
    case `default`
    case hover
    case active
    case focus
}

public enum ChipTagColor: CaseIterable {
    case blue      // 青系（デフォルト）
    case green     // 緑系
    case red       // 赤系
    case orange    // オレンジ系
    case purple    // パープル系
}

// MARK: - Style Configuration

private struct ChipTagStyleConfiguration {
    let backgroundColor: Color
    let borderColor: Color
    let textColor: Color
    let iconColor: Color
    let closeButtonColor: Color
    let showFocusRing: Bool

    init(state: ChipTagState, color: ChipTagColor) {
        self.showFocusRing = (state == .focus)

        switch state {
        case .default:
            self.backgroundColor = AppColor.Neutral.white
            self.borderColor = Self.getThemeColor(for: color)
            self.textColor = Self.getThemeColor(for: color)
            self.iconColor = Self.getThemeColor(for: color)
            self.closeButtonColor = Self.getThemeColor(for: color)

        case .hover:
            self.backgroundColor = Self.getTintColor(for: color)
            self.borderColor = Self.getThemeColor(for: color)
            self.textColor = Self.getThemeColor(for: color)
            self.iconColor = Self.getThemeColor(for: color)
            self.closeButtonColor = Self.getThemeColor(for: color)

        case .active:
            self.backgroundColor = Self.getActiveBackgroundColor(for: color)
            self.borderColor = Self.getActiveBackgroundColor(for: color)
            self.textColor = AppColor.Neutral.white
            self.iconColor = AppColor.Neutral.white
            self.closeButtonColor = AppColor.Neutral.white

        case .focus:
            // Focus状態はDefaultと同じスタイル + 外側にフォーカスリング
            self.backgroundColor = AppColor.Neutral.white
            self.borderColor = Self.getThemeColor(for: color)
            self.textColor = Self.getThemeColor(for: color)
            self.iconColor = Self.getThemeColor(for: color)
            self.closeButtonColor = Self.getThemeColor(for: color)
        }
    }

    // MARK: - Color Helpers

    private static func getThemeColor(for color: ChipTagColor) -> Color {
        switch color {
        case .blue:
            return AppColor.Primitive.Blue.blue700
        case .green:
            return AppColor.Primitive.Green.green700
        case .red:
            return AppColor.Primitive.Red.red700
        case .orange:
            return AppColor.Primitive.Orange.orange700
        case .purple:
            return AppColor.Primitive.Purple.purple700
        }
    }

    private static func getTintColor(for color: ChipTagColor) -> Color {
        switch color {
        case .blue:
            return AppColor.Primitive.Blue.blue50
        case .green:
            return AppColor.Primitive.Green.green50
        case .red:
            return AppColor.Primitive.Red.red50
        case .orange:
            return AppColor.Primitive.Orange.orange50
        case .purple:
            return AppColor.Primitive.Purple.purple50
        }
    }

    private static func getActiveBackgroundColor(for color: ChipTagColor) -> Color {
        switch color {
        case .blue:
            return AppColor.Primitive.Blue.blue700
        case .green:
            return AppColor.Primitive.Green.green700
        case .red:
            return AppColor.Primitive.Red.red700
        case .orange:
            return AppColor.Primitive.Orange.orange700
        case .purple:
            return AppColor.Primitive.Purple.purple700
        }
    }
}

// MARK: - ChipTag Component

public struct ChipTag: View {
    let text: String
    let color: ChipTagColor
    let state: ChipTagState
    let onRemove: () -> Void
    let customIcon: Image?

    private let configuration: ChipTagStyleConfiguration

    public init(
        text: String,
        color: ChipTagColor = .blue,
        state: ChipTagState = .default,
        customIcon: Image? = nil,
        onRemove: @escaping () -> Void
    ) {
        self.text = text
        self.color = color
        self.state = state
        self.customIcon = customIcon
        self.onRemove = onRemove
        self.configuration = ChipTagStyleConfiguration(state: state, color: color)
    }

    public var body: some View {
        HStack(spacing: 4) {
            // 左側アイコン（カスタムアイコンまたはDADS標準の斜線パターン）
            if let icon = customIcon {
                icon
                    .font(.system(size: 14))
                    .foregroundColor(configuration.iconColor)
                    .accessibilityHidden(true)
            } else {
                Text("//")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(configuration.iconColor)
                    .accessibilityHidden(true)
            }

            // テキスト
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(configuration.textColor)

            // 削除ボタン（×）
            Button(action: onRemove) {
                ZStack {
                    // 円形の背景
                    Circle()
                        .stroke(configuration.closeButtonColor, lineWidth: 1)
                        .frame(width: 16, height: 16)

                    // ×アイコン
                    Image(systemName: "xmark")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(configuration.closeButtonColor)
                }
                .frame(width: 20, height: 20)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            .accessibilityLabel("\(text)を削除")
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 999)
                .fill(configuration.backgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 999)
                .stroke(configuration.borderColor, lineWidth: 1)
        )
        .overlay(
            Group {
                if configuration.showFocusRing {
                    // DADS仕様: 黒のフォーカスリングのみ
                    RoundedRectangle(cornerRadius: 999)
                        .stroke(AppColor.Neutral.black, lineWidth: 3)
                        .padding(-3)
                }
            }
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("タグ: \(text)")
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(alignment: .leading, spacing: 32) {
            // 各状態の表示
            VStack(alignment: .leading, spacing: 16) {
                Text("ChipTag States")
                    .font(.title2.bold())

                VStack(alignment: .leading, spacing: 12) {
                    Text("Default")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    ChipTag(
                        text: "ラベル",
                        color: .blue,
                        state: .default,
                        onRemove: {}
                    )

                    Text("Hover")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    ChipTag(
                        text: "ラベル",
                        color: .blue,
                        state: .hover,
                        onRemove: {}
                    )

                    Text("Active")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    ChipTag(
                        text: "ラベル",
                        color: .blue,
                        state: .active,
                        onRemove: {}
                    )

                    Text("Focus")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    ChipTag(
                        text: "ラベル",
                        color: .blue,
                        state: .focus,
                        onRemove: {}
                    )
                }
            }

            Divider()

            // カラーバリエーション
            VStack(alignment: .leading, spacing: 16) {
                Text("Color Variations")
                    .font(.title2.bold())

                VStack(alignment: .leading, spacing: 12) {
                    ForEach(ChipTagColor.allCases, id: \.self) { color in
                        HStack(spacing: 8) {
                            ChipTag(
                                text: "Default",
                                color: color,
                                state: .default,
                                onRemove: {}
                            )
                            ChipTag(
                                text: "Hover",
                                color: color,
                                state: .hover,
                                onRemove: {}
                            )
                            ChipTag(
                                text: "Active",
                                color: color,
                                state: .active,
                                onRemove: {}
                            )
                        }
                    }
                }
            }

            Divider()

            // 実用例: 検索条件
            VStack(alignment: .leading, spacing: 16) {
                Text("実用例: サイト内検索の条件")
                    .font(.title2.bold())

                VStack(alignment: .leading, spacing: 8) {
                    Text("検索条件：")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    FlowLayout(spacing: 8) {
                        ChipTag(text: "現行法令", onRemove: {})
                        ChipTag(text: "法令", onRemove: {})
                        ChipTag(text: "勅令", onRemove: {})
                        ChipTag(text: "関連度順", onRemove: {})
                        ChipTag(text: "長いラベル長いラベル長いラベル長いラベル", onRemove: {})
                        ChipTag(text: "10件", onRemove: {})
                        ChipTag(text: "長いラベル", onRemove: {})
                    }
                }
            }

            Divider()

            // 実用例: ユーザータグ
            VStack(alignment: .leading, spacing: 16) {
                Text("実用例: 宛先のユーザータグ")
                    .font(.title2.bold())

                VStack(alignment: .leading, spacing: 12) {
                    Text("宛先")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    HStack(spacing: 8) {
                        ChipTag(
                            text: "デジ田 太郎",
                            customIcon: Image(systemName: "person.circle.fill"),
                            onRemove: {}
                        )
                        ChipTag(
                            text: "デジ演 実",
                            customIcon: Image(systemName: "person.circle.fill"),
                            onRemove: {}
                        )
                    }

                    Text("CC")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    ChipTag(
                        text: "デジ山 ひかり",
                        customIcon: Image(systemName: "person.circle.fill"),
                        onRemove: {}
                    )
                }
            }
        }
        .padding()
    }
    .preferredColorScheme(.light)
}

// MARK: - FlowLayout Helper

/// 複数のChipTagを自動で折り返し表示するためのレイアウト
private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }

                positions.append(CGPoint(x: x, y: y))
                lineHeight = max(lineHeight, size.height)
                x += size.width + spacing
            }

            self.size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}
