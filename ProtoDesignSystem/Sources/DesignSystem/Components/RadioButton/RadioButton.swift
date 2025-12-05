import SwiftUI

// MARK: - Enums

public enum RadioStatus {
    case normal
    case error
    case disabled
}

public enum RadioSize {
    case small
    case medium
    case large

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

public enum RadioGroupLayout {
    case inline
    case stacked
    case units
}

// MARK: - RadioButtonStyle

struct RadioButtonStyle {
    let status: RadioStatus
    let isSelected: Bool
    let isFocused: Bool

    var borderColor: Color {
        switch (status, isSelected) {
        case (.error, _):
            return AppColor.Semantic.Error.error1
        case (.disabled, _):
            return AppColor.Neutral.SolidGray.solidGray300
        case (.normal, true):
            return AppColor.Primitive.Blue.blue600
        case (.normal, false):
            return AppColor.Neutral.SolidGray.solidGray600
        }
    }

    var fillColor: Color {
        if status == .disabled {
            return isSelected ? AppColor.Neutral.SolidGray.solidGray300 : .clear
        }
        if status == .error && isSelected {
            return AppColor.Semantic.Error.error1
        }
        return isSelected ? AppColor.Primitive.Blue.blue600 : .clear
    }

    var foregroundColor: Color {
        switch status {
        case .disabled:
            return AppColor.Neutral.SolidGray.solidGray420
        case .error:
            return AppColor.Semantic.Error.error1
        case .normal:
            return AppColor.Neutral.SolidGray.solidGray900
        }
    }
}

// MARK: - RadioItem

public struct RadioItem: Identifiable {
    public let id: String
    public let label: String
    public let support: String?

    public init(id: String, label: String, support: String? = nil) {
        self.id = id
        self.label = label
        self.support = support
    }
}

// MARK: - RadioButton

public struct RadioButton: View {
    let label: String
    let supportText: String?
    let id: String

    @Binding var selectedId: String
    let status: RadioStatus
    let size: RadioSize
    let isFocused: Bool

    public init(
        label: String,
        supportText: String? = nil,
        id: String,
        selectedId: Binding<String>,
        status: RadioStatus = .normal,
        size: RadioSize = .medium,
        isFocused: Bool = false
    ) {
        self.label = label
        self.supportText = supportText
        self.id = id
        self._selectedId = selectedId
        self.status = status
        self.size = size
        self.isFocused = isFocused
    }

    var isSelected: Bool {
        selectedId == id
    }

    private var style: RadioButtonStyle {
        RadioButtonStyle(status: status, isSelected: isSelected, isFocused: isFocused)
    }

    public var body: some View {
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

                    if let supportText = supportText {
                        Text(supportText)
                            .font(.caption)
                            .foregroundColor(AppColor.Neutral.SolidGray.solidGray600)
                    }
                }

                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label)
        .accessibilityValue(isSelected ? "選択済み" : "未選択")
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
        .accessibilityHint(supportText ?? "")
    }

    private var radioCircle: some View {
        ZStack {
            // Base circle
            Circle()
                .fill(AppColor.Neutral.white)
                .frame(width: size.diameter, height: size.diameter)

            // Border circle
            Circle()
                .stroke(style.borderColor, lineWidth: 2)
                .frame(width: size.diameter, height: size.diameter)

            // Inner filled circle (when selected)
            if isSelected {
                Circle()
                    .fill(style.fillColor)
                    .frame(width: size.innerDiameter, height: size.innerDiameter)
            }

            // Focus rings
            if isFocused && status != .disabled {
                Circle()
                    .stroke(AppColor.Primitive.Yellow.yellow300, lineWidth: 3)
                    .frame(width: size.diameter + 6, height: size.diameter + 6)

                Circle()
                    .stroke(AppColor.Neutral.black, lineWidth: 3)
                    .frame(width: size.diameter + 12, height: size.diameter + 12)
            } else if isFocused && status == .disabled {
                // Accessibility focus ring for disabled state
                Circle()
                    .stroke(AppColor.Neutral.black, lineWidth: 3)
                    .frame(width: size.diameter + 12, height: size.diameter + 12)
            }
        }
        .frame(width: size.diameter, height: size.diameter)
    }
}

// MARK: - RadioGroup

public struct RadioGroup: View {
    let title: String?
    let required: Bool
    let supportText: String?
    let errorText: String?

    let layout: RadioGroupLayout
    let items: [RadioItem]
    let size: RadioSize

    @Binding var selectedId: String

    public init(
        title: String? = nil,
        required: Bool = false,
        supportText: String? = nil,
        errorText: String? = nil,
        layout: RadioGroupLayout = .stacked,
        items: [RadioItem],
        size: RadioSize = .medium,
        selectedId: Binding<String>
    ) {
        self.title = title
        self.required = required
        self.supportText = supportText
        self.errorText = errorText
        self.layout = layout
        self.items = items
        self.size = size
        self._selectedId = selectedId
    }

    var status: RadioStatus {
        if errorText != nil {
            return .error
        }
        return .normal
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title with required mark
            if let title = title {
                HStack(spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(AppColor.Neutral.SolidGray.solidGray900)

                    if required {
                        Text("※必須")
                            .foregroundColor(AppColor.Semantic.Error.error1)
                            .font(.subheadline)
                    }
                }
            }

            // Support text
            if let supportText = supportText {
                Text(supportText)
                    .font(.caption)
                    .foregroundColor(AppColor.Neutral.SolidGray.solidGray600)
            }

            // Radio buttons layout
            switch layout {
            case .inline:
                inlineLayout
            case .stacked:
                stackedLayout
            case .units:
                unitsLayout
            }

            // Error message
            if let errorText = errorText {
                Text("* \(errorText)")
                    .foregroundColor(AppColor.Semantic.Error.error1)
                    .font(.caption)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(title ?? "ラジオボタングループ")
        .accessibilityHint(required ? "必須項目です" : "")
    }

    private var inlineLayout: some View {
        HStack(spacing: 24) {
            ForEach(items) { item in
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
            ForEach(items) { item in
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
            ForEach(items) { item in
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

// MARK: - Preview

#Preview("RadioButton - Basic States") {
    VStack(alignment: .leading, spacing: 24) {
        Text("RadioButton - Basic States").font(.title2.bold())

        // Default
        HStack(spacing: 20) {
            Text("Default").frame(width: 100, alignment: .trailing).font(.caption)
            RadioButton(label: "Small", id: "default", selectedId: .constant(""), size: .small)
            RadioButton(label: "Medium", id: "default", selectedId: .constant(""), size: .medium)
            RadioButton(label: "Large", id: "default", selectedId: .constant(""), size: .large)
        }

        // Checked
        HStack(spacing: 20) {
            Text("Checked").frame(width: 100, alignment: .trailing).font(.caption)
            RadioButton(label: "Small", id: "checked", selectedId: .constant("checked"), size: .small)
            RadioButton(label: "Medium", id: "checked", selectedId: .constant("checked"), size: .medium)
            RadioButton(label: "Large", id: "checked", selectedId: .constant("checked"), size: .large)
        }
    }
    .padding()
    .preferredColorScheme(.light)
}

#Preview("RadioButton - Focus States") {
    VStack(alignment: .leading, spacing: 24) {
        Text("RadioButton - Focus States").font(.title2.bold())

        // Default + Focus
        HStack(spacing: 20) {
            Text("Default : focus").frame(width: 120, alignment: .trailing).font(.caption)
            RadioButton(label: "Small", id: "focus", selectedId: .constant(""), size: .small, isFocused: true)
            RadioButton(label: "Medium", id: "focus", selectedId: .constant(""), size: .medium, isFocused: true)
            RadioButton(label: "Large", id: "focus", selectedId: .constant(""), size: .large, isFocused: true)
        }

        // Checked + Focus
        HStack(spacing: 20) {
            Text("Checked : focus").frame(width: 120, alignment: .trailing).font(.caption)
            RadioButton(label: "Small", id: "checked-focus", selectedId: .constant("checked-focus"), size: .small, isFocused: true)
            RadioButton(label: "Medium", id: "checked-focus", selectedId: .constant("checked-focus"), size: .medium, isFocused: true)
            RadioButton(label: "Large", id: "checked-focus", selectedId: .constant("checked-focus"), size: .large, isFocused: true)
        }
    }
    .padding()
    .preferredColorScheme(.light)
}

#Preview("RadioButton - Error States") {
    VStack(alignment: .leading, spacing: 24) {
        Text("RadioButton - Error States").font(.title2.bold())

        // Default Error
        HStack(spacing: 20) {
            Text("Default Error").frame(width: 120, alignment: .trailing).font(.caption)
            RadioButton(label: "Small", id: "error", selectedId: .constant(""), status: .error, size: .small)
            RadioButton(label: "Medium", id: "error", selectedId: .constant(""), status: .error, size: .medium)
            RadioButton(label: "Large", id: "error", selectedId: .constant(""), status: .error, size: .large)
        }

        // Checked Error
        HStack(spacing: 20) {
            Text("Checked Error").frame(width: 120, alignment: .trailing).font(.caption)
            RadioButton(label: "Small", id: "checked-error", selectedId: .constant("checked-error"), status: .error, size: .small)
            RadioButton(label: "Medium", id: "checked-error", selectedId: .constant("checked-error"), status: .error, size: .medium)
            RadioButton(label: "Large", id: "checked-error", selectedId: .constant("checked-error"), status: .error, size: .large)
        }

        // Default Error + Focus
        HStack(spacing: 20) {
            Text("Default Error : focus").frame(width: 140, alignment: .trailing).font(.caption)
            RadioButton(label: "Small", id: "error-focus", selectedId: .constant(""), status: .error, size: .small, isFocused: true)
            RadioButton(label: "Medium", id: "error-focus", selectedId: .constant(""), status: .error, size: .medium, isFocused: true)
            RadioButton(label: "Large", id: "error-focus", selectedId: .constant(""), status: .error, size: .large, isFocused: true)
        }

        // Checked Error + Focus
        HStack(spacing: 20) {
            Text("Checked Error : focus").frame(width: 140, alignment: .trailing).font(.caption)
            RadioButton(label: "Small", id: "checked-error-focus", selectedId: .constant("checked-error-focus"), status: .error, size: .small, isFocused: true)
            RadioButton(label: "Medium", id: "checked-error-focus", selectedId: .constant("checked-error-focus"), status: .error, size: .medium, isFocused: true)
            RadioButton(label: "Large", id: "checked-error-focus", selectedId: .constant("checked-error-focus"), status: .error, size: .large, isFocused: true)
        }
    }
    .padding()
    .preferredColorScheme(.light)
}

#Preview("RadioButton - Disabled & Groups") {
    ScrollView {
        VStack(alignment: .leading, spacing: 32) {
            VStack(alignment: .leading, spacing: 24) {
                Text("Disabled States").font(.title2.bold())

                // Default Disabled
                HStack(spacing: 20) {
                    Text("Default Disabled").frame(width: 130, alignment: .trailing).font(.caption)
                    RadioButton(label: "Small", id: "disabled", selectedId: .constant(""), status: .disabled, size: .small)
                    RadioButton(label: "Medium", id: "disabled", selectedId: .constant(""), status: .disabled, size: .medium)
                    RadioButton(label: "Large", id: "disabled", selectedId: .constant(""), status: .disabled, size: .large)
                }

                // Checked Disabled
                HStack(spacing: 20) {
                    Text("Checked Disabled").frame(width: 130, alignment: .trailing).font(.caption)
                    RadioButton(label: "Small", id: "checked-disabled", selectedId: .constant("checked-disabled"), status: .disabled, size: .small)
                    RadioButton(label: "Medium", id: "checked-disabled", selectedId: .constant("checked-disabled"), status: .disabled, size: .medium)
                    RadioButton(label: "Large", id: "checked-disabled", selectedId: .constant("checked-disabled"), status: .disabled, size: .large)
                }

                // Default Disabled + Focus
                HStack(spacing: 20) {
                    Text("Default Disabled : focus").frame(width: 150, alignment: .trailing).font(.caption2)
                    RadioButton(label: "Small", id: "disabled-focus", selectedId: .constant(""), status: .disabled, size: .small, isFocused: true)
                    RadioButton(label: "Medium", id: "disabled-focus", selectedId: .constant(""), status: .disabled, size: .medium, isFocused: true)
                    RadioButton(label: "Large", id: "disabled-focus", selectedId: .constant(""), status: .disabled, size: .large, isFocused: true)
                }

                // Checked Disabled + Focus
                HStack(spacing: 20) {
                    Text("Checked Disabled : focus").frame(width: 150, alignment: .trailing).font(.caption2)
                    RadioButton(label: "Small", id: "checked-disabled-focus", selectedId: .constant("checked-disabled-focus"), status: .disabled, size: .small, isFocused: true)
                    RadioButton(label: "Medium", id: "checked-disabled-focus", selectedId: .constant("checked-disabled-focus"), status: .disabled, size: .medium, isFocused: true)
                    RadioButton(label: "Large", id: "checked-disabled-focus", selectedId: .constant("checked-disabled-focus"), status: .disabled, size: .large, isFocused: true)
                }
            }

            Divider()

            VStack(alignment: .leading, spacing: 24) {
                Text("RadioGroup Layouts").font(.title2.bold())

                // Inline Layout
                RadioGroup(
                    title: "Inline - Small",
                    layout: .inline,
                    items: [
                        RadioItem(id: "1", label: "選択肢1"),
                        RadioItem(id: "2", label: "選択肢2"),
                        RadioItem(id: "3", label: "選択肢3")
                    ],
                    size: .small,
                    selectedId: .constant("1")
                )

                // Stacked Layout
                RadioGroup(
                    title: "Stacked - Medium",
                    supportText: "サポートテキスト",
                    layout: .stacked,
                    items: [
                        RadioItem(id: "1", label: "選択肢1"),
                        RadioItem(id: "2", label: "選択肢2"),
                        RadioItem(id: "3", label: "選択肢3")
                    ],
                    size: .medium,
                    selectedId: .constant("2")
                )

                // Units Layout
                RadioGroup(
                    title: "Units - Large",
                    errorText: "エラーテキストが入ります",
                    layout: .units,
                    items: [
                        RadioItem(id: "1", label: "選択肢1"),
                        RadioItem(id: "2", label: "選択肢2"),
                        RadioItem(id: "3", label: "選択肢3")
                    ],
                    size: .large,
                    selectedId: .constant("")
                )
            }
        }
        .padding()
    }
    .preferredColorScheme(.light)
}
