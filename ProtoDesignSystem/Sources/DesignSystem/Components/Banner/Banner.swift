import SwiftUI

// MARK: - Custom Shapes

public struct Triangle: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

public struct Octagon: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        let centerX = rect.midX
        let centerY = rect.midY
        let radius = min(rect.width, rect.height) / 2

        // Calculate points for a regular octagon
        for i in 0..<8 {
            let angle = CGFloat(i) * .pi / 4 - .pi / 8
            let x = centerX + radius * cos(angle)
            let y = centerY + radius * sin(angle)

            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
}

// MARK: - Enums

public enum BannerStatus: CaseIterable {
    case success
    case error
    case warning
    case info
    case infoNeutral

    var color: Color {
        switch self {
        case .success:
            return AppColor.Primitive.Green.green700
        case .error:
            return AppColor.Primitive.Red.red700
        case .warning:
            return AppColor.Primitive.Orange.orange700
        case .info:
            return AppColor.Primitive.Blue.blue700
        case .infoNeutral:
            return AppColor.Neutral.SolidGray.solidGray600
        }
    }

    var iconName: String {
        switch self {
        case .success:
            return "checkmark"
        case .error:
            return "xmark"
        case .warning:
            return "exclamationmark"
        case .info, .infoNeutral:
            return "info"
        }
    }

    var label: String {
        switch self {
        case .success:
            return "成功"
        case .error:
            return "エラー"
        case .warning:
            return "警告"
        case .info:
            return "情報"
        case .infoNeutral:
            return "情報"
        }
    }

    enum IconShape {
        case circle
        case triangle
        case octagon
    }

    var iconShape: IconShape {
        switch self {
        case .success, .info, .infoNeutral:
            return .circle
        case .error:
            return .octagon
        case .warning:
            return .triangle
        }
    }
}

public enum BannerVariant: CaseIterable {
    case standard
    case colorChip
}

public enum BannerLayout: CaseIterable {
    case vertical
    case horizontal
}

// MARK: - Banner Component

public struct Banner: View {
    let status: BannerStatus
    let title: String
    let date: String?
    let descriptionText: String?
    let chipLabel: String?
    let actionTitle: String?
    let onAction: (() -> Void)?
    let onClose: () -> Void
    let layout: BannerLayout
    let variant: BannerVariant

    public init(
        status: BannerStatus,
        title: String,
        date: String? = nil,
        descriptionText: String? = nil,
        chipLabel: String? = nil,
        actionTitle: String? = nil,
        onAction: (() -> Void)? = nil,
        onClose: @escaping () -> Void,
        layout: BannerLayout = .vertical,
        variant: BannerVariant = .standard
    ) {
        self.status = status
        self.title = title
        self.date = date
        self.descriptionText = descriptionText
        self.chipLabel = chipLabel
        self.actionTitle = actionTitle
        self.onAction = onAction
        self.onClose = onClose
        self.layout = layout
        self.variant = variant
    }

    public var body: some View {
        Group {
            switch layout {
            case .vertical:
                verticalLayout
            case .horizontal:
                horizontalLayout
            }
        }
        .background(AppColor.Neutral.white)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(status.color, lineWidth: 2)
        )
        .cornerRadius(8)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(status.label)バナー、\(title)")
    }

    // MARK: - Status Icon

    private var statusIcon: some View {
        Group {
            switch status.iconShape {
            case .circle:
                ZStack {
                    Circle()
                        .fill(status.color)
                        .frame(width: 24, height: 24)
                    Image(systemName: status.iconName)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(AppColor.Neutral.white)
                }
                .frame(width: 24, height: 24)

            case .triangle:
                ZStack {
                    Triangle()
                        .fill(status.color)
                        .frame(width: 28, height: 28)
                    Image(systemName: status.iconName)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(AppColor.Neutral.white)
                        .offset(y: 1)
                }
                .frame(width: 28, height: 28)

            case .octagon:
                ZStack {
                    Octagon()
                        .fill(status.color)
                        .frame(width: 24, height: 24)
                    Image(systemName: status.iconName)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(AppColor.Neutral.white)
                }
                .frame(width: 24, height: 24)
            }
        }
        .accessibilityHidden(true)
    }

    // MARK: - Close Button

    private var closeButton: some View {
        Button(action: onClose) {
            Image(systemName: "xmark")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(variant == .colorChip ? AppColor.Neutral.white : AppColor.Neutral.SolidGray.solidGray700)
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel("閉じる")
    }

    // MARK: - Vertical Layout

    private var verticalLayout: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(alignment: .center, spacing: 8) {
                statusIcon

                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(variant == .colorChip ? AppColor.Neutral.white : AppColor.Neutral.SolidGray.solidGray900)

                Spacer()

                closeButton
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                variant == .colorChip ? status.color : Color.clear
            )

            // Content
            VStack(alignment: .leading, spacing: 8) {
                if let date = date {
                    Text(date)
                        .font(.system(size: 12))
                        .foregroundColor(AppColor.Neutral.SolidGray.solidGray600)
                }

                if let descriptionText = descriptionText {
                    Text(descriptionText)
                        .font(.system(size: 14))
                        .foregroundColor(AppColor.Neutral.SolidGray.solidGray900)
                }

                if let chipLabel = chipLabel {
                    ChipLabel(
                        text: chipLabel,
                        style: .outlined,
                        color: statusToChipColor(status)
                    )
                }

                if let actionTitle = actionTitle {
                    Button(action: { onAction?() }) {
                        Text(actionTitle)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(AppColor.Neutral.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(status.color)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(16)
        }
    }

    // MARK: - Horizontal Layout

    private var horizontalLayout: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack {
                statusIcon
                Spacer()
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(AppColor.Neutral.SolidGray.solidGray900)

                    Spacer()

                    closeButton
                }

                if let date = date {
                    Text(date)
                        .font(.system(size: 12))
                        .foregroundColor(AppColor.Neutral.SolidGray.solidGray600)
                }

                if let descriptionText = descriptionText {
                    Text(descriptionText)
                        .font(.system(size: 14))
                        .foregroundColor(AppColor.Neutral.SolidGray.solidGray900)
                }

                HStack(spacing: 8) {
                    if let chipLabel = chipLabel {
                        ChipLabel(
                            text: chipLabel,
                            style: .outlined,
                            color: statusToChipColor(status)
                        )
                    }

                    if let actionTitle = actionTitle {
                        Button(action: { onAction?() }) {
                            Text(actionTitle)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(AppColor.Neutral.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(status.color)
                                .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .padding(16)
    }

    // MARK: - Helper

    private func statusToChipColor(_ status: BannerStatus) -> ChipLabelColor {
        switch status {
        case .success:
            return .success
        case .error:
            return .error
        case .warning:
            return .warning
        case .info, .infoNeutral:
            return .info
        }
    }
}

// MARK: - Preview

import SwiftUI

// MARK: - Banner Previews - Split by Variant and Layout

#Preview("Banner - Status Icons") {
    VStack(alignment: .leading, spacing: 16) {
        Text("Status Icons")
            .font(.headline)

        HStack(spacing: 16) {
            ForEach(BannerStatus.allCases, id: \.self) { status in
                VStack(spacing: 8) {
                    Group {
                        switch status.iconShape {
                        case .circle:
                            ZStack {
                                Circle()
                                    .fill(status.color)
                                    .frame(width: 24, height: 24)
                                Image(systemName: status.iconName)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(AppColor.Neutral.white)
                            }
                            .frame(width: 24, height: 24)

                        case .triangle:
                            ZStack {
                                Triangle()
                                    .fill(status.color)
                                    .frame(width: 28, height: 28)
                                Image(systemName: status.iconName)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(AppColor.Neutral.white)
                                    .offset(y: 1)
                            }
                            .frame(width: 28, height: 28)

                        case .octagon:
                            ZStack {
                                Octagon()
                                    .fill(status.color)
                                    .frame(width: 24, height: 24)
                                Image(systemName: status.iconName)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(AppColor.Neutral.white)
                            }
                            .frame(width: 24, height: 24)
                        }
                    }

                    Text(status.label)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    .padding()
}

#Preview("Banner - Standard & Vertical") {
    ScrollView {
        VStack(alignment: .leading, spacing: 16) {
            Text("Standard / Vertical Layout")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(BannerStatus.allCases, id: \.self) { status in
                        Banner(
                            status: status,
                            title: "バナータイトル",
                            date: "年月日",
                            descriptionText: "バナーデスクリプション",
                            chipLabel: "ラベル",
                            actionTitle: "アクション",
                            onAction: {},
                            onClose: {},
                            layout: .vertical,
                            variant: .standard
                        )
                        .frame(width: 280)
                    }
                }
            }
        }
        .padding()
    }
    .preferredColorScheme(.light)
}

#Preview("Banner - ColorChip & Vertical") {
    ScrollView {
        VStack(alignment: .leading, spacing: 16) {
            Text("Color Chip / Vertical Layout")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(BannerStatus.allCases, id: \.self) { status in
                        Banner(
                            status: status,
                            title: "バナータイトル",
                            date: "年月日",
                            descriptionText: "バナーデスクリプション",
                            chipLabel: "ラベル",
                            actionTitle: "アクション",
                            onAction: {},
                            onClose: {},
                            layout: .vertical,
                            variant: .colorChip
                        )
                        .frame(width: 280)
                    }
                }
            }
        }
        .padding()
    }
    .preferredColorScheme(.light)
}

#Preview("Banner - Standard & Horizontal") {
    ScrollView {
        VStack(alignment: .leading, spacing: 16) {
            Text("Standard / Horizontal Layout")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(BannerStatus.allCases, id: \.self) { status in
                        Banner(
                            status: status,
                            title: "バナータイトル",
                            date: "年月日",
                            descriptionText: "バナーデスクリプション",
                            chipLabel: "ラベル",
                            actionTitle: "アクション",
                            onAction: {},
                            onClose: {},
                            layout: .horizontal,
                            variant: .standard
                        )
                        .frame(width: 320)
                    }
                }
            }
        }
        .padding()
    }
    .preferredColorScheme(.light)
}

#Preview("Banner - ColorChip & Horizontal") {
    ScrollView {
        VStack(alignment: .leading, spacing: 16) {
            Text("Color Chip / Horizontal Layout")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(BannerStatus.allCases, id: \.self) { status in
                        Banner(
                            status: status,
                            title: "バナータイトル",
                            date: "年月日",
                            descriptionText: "バナーデスクリプション",
                            chipLabel: "ラベル",
                            actionTitle: "アクション",
                            onAction: {},
                            onClose: {},
                            layout: .horizontal,
                            variant: .colorChip
                        )
                        .frame(width: 320)
                    }
                }
            }
        }
        .padding()
    }
    .preferredColorScheme(.light)
}

#Preview("Banner - Real-World Examples") {
    VStack(spacing: 16) {
        Text("実用例")
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)

        Banner(
            status: .success,
            title: "登録手続きは全て完了しました",
            descriptionText: "ダミーテキストは、デザインの作成時に使用される仮の文章です。",
            onClose: {},
            layout: .vertical,
            variant: .standard
        )

        Banner(
            status: .error,
            title: "操作を完了できませんでした",
            descriptionText: "ダミーテキストは、デザインの作成時に使用される仮の文章です。",
            onClose: {},
            layout: .vertical,
            variant: .colorChip
        )

        Banner(
            status: .warning,
            title: "偽SNSアカウントにご注意ください",
            descriptionText: "ダミーテキストは、デザインの作成時に使用される仮の文章です。",
            onClose: {},
            layout: .vertical,
            variant: .standard
        )
    }
    .padding()
    .preferredColorScheme(.light)
}
