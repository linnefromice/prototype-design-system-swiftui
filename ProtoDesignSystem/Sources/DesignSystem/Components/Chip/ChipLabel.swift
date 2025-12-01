import SwiftUI

// MARK: - Enums

public enum ChipLabelStyle: CaseIterable {
    case textOnly
    case outlined
    case outlinedWithFill
    case fillOnly
}

public enum ChipLabelColor: CaseIterable {
    case success    // 緑系（成功）
    case error      // 赤系（失敗）
    case warning    // オレンジ系（注意）
    case info       // 青系（情報）
    case cyan       // シアン系
    case lime       // ライム系
    case purple     // パープル系
    case magenta    // マゼンタ系
    case neutral    // グレー系
}

// MARK: - Style Configuration

private struct ChipLabelStyleConfiguration {
    let backgroundColor: Color?
    let borderColor: Color?
    let textColor: Color
    let iconColor: Color

    init(
        style: ChipLabelStyle,
        color: ChipLabelColor
    ) {
        switch style {
        case .textOnly:
            self.backgroundColor = nil
            self.borderColor = nil
            self.textColor = Self.getTextColor(for: color, style: .textOnly)
            self.iconColor = Self.getTextColor(for: color, style: .textOnly)

        case .outlined:
            self.backgroundColor = AppColor.Neutral.white
            self.borderColor = Self.getBorderColor(for: color)
            self.textColor = Self.getTextColor(for: color, style: .outlined)
            self.iconColor = Self.getTextColor(for: color, style: .outlined)

        case .outlinedWithFill:
            self.backgroundColor = Self.getTintColor(for: color)
            self.borderColor = Self.getBorderColor(for: color)
            self.textColor = Self.getTextColor(for: color, style: .outlinedWithFill)
            self.iconColor = Self.getTextColor(for: color, style: .outlinedWithFill)

        case .fillOnly:
            self.backgroundColor = Self.getFillColor(for: color)
            self.borderColor = nil
            self.textColor = AppColor.Neutral.white
            self.iconColor = AppColor.Neutral.white
        }
    }

    // MARK: - Color Helpers

    private static func getTextColor(for color: ChipLabelColor, style: ChipLabelStyle) -> Color {
        if style == .fillOnly {
            return AppColor.Neutral.white
        }

        switch color {
        case .success:
            return AppColor.Primitive.Green.green700
        case .error:
            return AppColor.Primitive.Red.red700
        case .warning:
            return AppColor.Primitive.Orange.orange700
        case .info:
            return AppColor.Primitive.Blue.blue700
        case .cyan:
            return AppColor.Primitive.Cyan.cyan700
        case .lime:
            return AppColor.Primitive.Lime.lime700
        case .purple:
            return AppColor.Primitive.Purple.purple700
        case .magenta:
            return AppColor.Primitive.Magenta.magenta700
        case .neutral:
            return AppColor.Neutral.SolidGray.solidGray700
        }
    }

    private static func getBorderColor(for color: ChipLabelColor) -> Color {
        switch color {
        case .success:
            return AppColor.Primitive.Green.green600
        case .error:
            return AppColor.Primitive.Red.red600
        case .warning:
            return AppColor.Primitive.Orange.orange600
        case .info:
            return AppColor.Primitive.Blue.blue600
        case .cyan:
            return AppColor.Primitive.Cyan.cyan600
        case .lime:
            return AppColor.Primitive.Lime.lime600
        case .purple:
            return AppColor.Primitive.Purple.purple600
        case .magenta:
            return AppColor.Primitive.Magenta.magenta600
        case .neutral:
            return AppColor.Neutral.SolidGray.solidGray600
        }
    }

    private static func getTintColor(for color: ChipLabelColor) -> Color {
        switch color {
        case .success:
            return AppColor.Primitive.Green.green50
        case .error:
            return AppColor.Primitive.Red.red50
        case .warning:
            return AppColor.Primitive.Orange.orange50
        case .info:
            return AppColor.Primitive.Blue.blue50
        case .cyan:
            return AppColor.Primitive.Cyan.cyan50
        case .lime:
            return AppColor.Primitive.Lime.lime50
        case .purple:
            return AppColor.Primitive.Purple.purple50
        case .magenta:
            return AppColor.Primitive.Magenta.magenta50
        case .neutral:
            return AppColor.Neutral.SolidGray.solidGray50
        }
    }

    private static func getFillColor(for color: ChipLabelColor) -> Color {
        switch color {
        case .success:
            return AppColor.Primitive.Green.green700
        case .error:
            return AppColor.Primitive.Red.red700
        case .warning:
            return AppColor.Primitive.Orange.orange700
        case .info:
            return AppColor.Primitive.Blue.blue700
        case .cyan:
            return AppColor.Primitive.Cyan.cyan700
        case .lime:
            return AppColor.Primitive.Lime.lime700
        case .purple:
            return AppColor.Primitive.Purple.purple700
        case .magenta:
            return AppColor.Primitive.Magenta.magenta700
        case .neutral:
            return AppColor.Neutral.SolidGray.solidGray700
        }
    }
}

// MARK: - ChipLabel Component

public struct ChipLabel: View {
    let text: String
    let style: ChipLabelStyle
    let color: ChipLabelColor

    private let configuration: ChipLabelStyleConfiguration

    public init(
        text: String,
        style: ChipLabelStyle = .outlined,
        color: ChipLabelColor = .info
    ) {
        self.text = text
        self.style = style
        self.color = color
        self.configuration = ChipLabelStyleConfiguration(style: style, color: color)
    }

    public var body: some View {
        HStack(spacing: 3) {
            // DADS標準アイコン（斜線パターン）をテキストで表現
            Text("//")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(configuration.iconColor)
                .accessibilityHidden(true)

            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(configuration.textColor)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Group {
                if let backgroundColor = configuration.backgroundColor {
                    RoundedRectangle(cornerRadius: 999)
                        .fill(backgroundColor)
                }
            }
        )
        .overlay(
            Group {
                if let borderColor = configuration.borderColor {
                    RoundedRectangle(cornerRadius: 999)
                        .stroke(borderColor, lineWidth: 1)
                }
            }
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(text)
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(alignment: .leading, spacing: 32) {
            // Text Only
            VStack(alignment: .leading, spacing: 12) {
                Text("Text Only")
                    .font(.headline)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(ChipLabelColor.allCases, id: \.self) { color in
                            ChipLabel(
                                text: "ラベル",
                                style: .textOnly,
                                color: color
                            )
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }

            // Outlined
            VStack(alignment: .leading, spacing: 12) {
                Text("Outlined")
                    .font(.headline)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(ChipLabelColor.allCases, id: \.self) { color in
                            ChipLabel(
                                text: "ラベル",
                                style: .outlined,
                                color: color
                            )
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }

            // Outlined with Fill
            VStack(alignment: .leading, spacing: 12) {
                Text("Outlined with Fill")
                    .font(.headline)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(ChipLabelColor.allCases, id: \.self) { color in
                            ChipLabel(
                                text: "ラベル",
                                style: .outlinedWithFill,
                                color: color
                            )
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }

            // Fill Only
            VStack(alignment: .leading, spacing: 12) {
                Text("Fill Only")
                    .font(.headline)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(ChipLabelColor.allCases, id: \.self) { color in
                            ChipLabel(
                                text: "ラベル",
                                style: .fillOnly,
                                color: color
                            )
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }

            Divider()

            // 実用例: テーブルのステータス表示
            VStack(alignment: .leading, spacing: 12) {
                Text("実用例: テーブルのステータス")
                    .font(.headline)

                VStack(spacing: 8) {
                    HStack {
                        Text("共創プロジェクト")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        ChipLabel(text: "下書き", style: .outlined, color: .neutral)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(8)

                    HStack {
                        Text("組織戦略プロジェクト")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        ChipLabel(text: "公開済み", style: .fillOnly, color: .success)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(8)

                    HStack {
                        Text("基盤改善プロジェクト")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        ChipLabel(text: "下書き", style: .outlined, color: .neutral)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(8)

                    HStack {
                        Text("人材育成プロジェクト")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        ChipLabel(text: "公開済み", style: .fillOnly, color: .success)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(8)

                    HStack {
                        Text("組織戦略プロジェクト")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        ChipLabel(text: "公開予約中", style: .outlinedWithFill, color: .warning)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(8)
                }
            }

            // 実用例: セマンティックカラー
            VStack(alignment: .leading, spacing: 12) {
                Text("実用例: セマンティックカラー")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        ChipLabel(text: "成功", style: .outlined, color: .success)
                        ChipLabel(text: "成功", style: .outlinedWithFill, color: .success)
                        ChipLabel(text: "成功", style: .fillOnly, color: .success)
                    }

                    HStack(spacing: 8) {
                        ChipLabel(text: "失敗", style: .outlined, color: .error)
                        ChipLabel(text: "失敗", style: .outlinedWithFill, color: .error)
                        ChipLabel(text: "失敗", style: .fillOnly, color: .error)
                    }

                    HStack(spacing: 8) {
                        ChipLabel(text: "注意", style: .outlined, color: .warning)
                        ChipLabel(text: "注意", style: .outlinedWithFill, color: .warning)
                        ChipLabel(text: "注意", style: .fillOnly, color: .warning)
                    }

                    HStack(spacing: 8) {
                        ChipLabel(text: "情報", style: .outlined, color: .info)
                        ChipLabel(text: "情報", style: .outlinedWithFill, color: .info)
                        ChipLabel(text: "情報", style: .fillOnly, color: .info)
                    }
                }
            }
        }
        .padding()
    }
    .preferredColorScheme(.light)
}
