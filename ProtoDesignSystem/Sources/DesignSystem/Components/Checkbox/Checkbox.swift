import SwiftUI

public enum CheckboxTypeVariant {
    case _default
    case error
    case disabled

    func contentsBgColor(isOn: Bool, isHover: Bool) -> Color {
        switch self {
        case ._default:
            return isOn
                ? isHover ? AppColor.Primitive.Blue.blue1100 : AppColor.Primitive.Blue.blue900
                : AppColor.Neutral.white
        case .error:
            return isOn
                ? isHover ? AppColor.Primitive.Red.red1000 : AppColor.Semantic.Error.error1
                : AppColor.Neutral.white
        case .disabled:
            return isOn
                ? AppColor.Neutral.SolidGray.solidGray300
                : AppColor.Neutral.SolidGray.solidGray50
        }
    }

    var borderColor: Color {
        switch self {
        case ._default: return AppColor.Neutral.SolidGray.solidGray400
        case .error: return AppColor.Semantic.Error.error1
        case .disabled: return AppColor.Neutral.SolidGray.solidGray300
        }
    }

}

public enum CheckboxMarkVariant {
    case _default
    case indeterminate

    func image(baseSize: Int) -> AnyView {
        switch self {
        case ._default:
            return AnyView(
                Image(systemName: "checkmark")
                    .resizable()
                    .frame(
                        width: CGFloat(baseSize - 16),
                        height: CGFloat(baseSize - 16)
                    ))
        case .indeterminate: return AnyView(Image(systemName: "minus"))
        }
    }
}

public enum CheckboxSizeVariant: Identifiable, Hashable {
    case sm
    case md
    case lg
    case custom(Int)

    public var size: Int {
        switch self {
        case .sm: return 24
        case .md: return 32
        case .lg: return 40
        case .custom(let size): return size
        }
    }

    public var id: String {
        let base = "checkbox_size_variant_"
        switch self {
        case .sm: return base + "sm"
        case .md: return base + "md"
        case .lg: return base + "lg"
        case .custom(let size): return base + "custom_\(size)"
        }
    }
}

public struct CheckboxStyle: ToggleStyle {
    let typeVariant: CheckboxTypeVariant
    let markVariant: CheckboxMarkVariant
    let sizeVariant: CheckboxSizeVariant
    let isHover: Bool
    let isFocused: Bool

    init(
        typeVariant: CheckboxTypeVariant = ._default,
        markVariant: CheckboxMarkVariant = ._default,
        sizeVariant: CheckboxSizeVariant = .md,
        isHover: Bool = false,
        isFocused: Bool = false
    ) {
        self.typeVariant = typeVariant
        self.markVariant = markVariant
        self.sizeVariant = sizeVariant
        self.isHover = isHover
        self.isFocused = isFocused
    }

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            Button {
                configuration.isOn.toggle()
            } label: {
                ZStack {
                    if isHover {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(AppColor.Neutral.black, lineWidth: 6)
                            .frame(
                                width: CGFloat(sizeVariant.size), height: CGFloat(sizeVariant.size))
                    }

                    if isFocused {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(AppColor.Primitive.Yellow.yellow300, lineWidth: 2)
                            .frame(
                                width: CGFloat(sizeVariant.size), height: CGFloat(sizeVariant.size))
                    }

                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                typeVariant.contentsBgColor(
                                    isOn: configuration.isOn, isHover: isHover)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(typeVariant.borderColor, lineWidth: 1)
                            )

                        if configuration.isOn {
                            markVariant.image(baseSize: sizeVariant.size)
                                .foregroundColor(AppColor.Neutral.white)
                        }
                    }
                    .frame(
                        width: CGFloat(sizeVariant.size - 4), height: CGFloat(sizeVariant.size - 4))
                }
            }
            .buttonStyle(.plain)
        }
    }

    // @ViewBuilder
    // func imageView(baseSize: Int) -> some View {
    //     switch markVariant {
    //     case ._default:
    //         return
    //             Image(systemName: "checkmark")
    //                 .resizable()
    //                 .frame(
    //                     width: CGFloat(baseSize - 16),
    //                     height: CGFloat(baseSize - 16)
    //                 )
    //     case .indeterminate: return Image(systemName: "minus")
    //     }
    // }
}

extension ToggleStyle where Self == CheckboxStyle {
    public static var customCheckbox: CheckboxStyle {
        CheckboxStyle()
    }
}

#Preview {
    @Previewable @State var isOn: Bool = true

    let sizeVariants: [CheckboxSizeVariant] = [.sm, .md, .lg]

    VStack(spacing: 32) {
        // Default state row
        HStack(spacing: 48) {
            ForEach(sizeVariants, id: \.self) { sizeVariant in
                Toggle("", isOn: $isOn)
                    .toggleStyle(CheckboxStyle(sizeVariant: sizeVariant))
            }
        }

        // Hovered state row
        HStack(spacing: 48) {
            ForEach(sizeVariants, id: \.self) { sizeVariant in
                Toggle("", isOn: $isOn)
                    .toggleStyle(CheckboxStyle(sizeVariant: sizeVariant, isHover: true))
            }
        }

        // Indeterminate state row
        HStack(spacing: 48) {
            ForEach(sizeVariants, id: \.self) { sizeVariant in
                Toggle("", isOn: $isOn)
                    .toggleStyle(
                        CheckboxStyle(markVariant: .indeterminate, sizeVariant: sizeVariant))
            }
        }

        // Indeterminate + Hovered state row
        HStack(spacing: 48) {
            ForEach(sizeVariants, id: \.self) { sizeVariant in
                Toggle("", isOn: $isOn)
                    .toggleStyle(
                        CheckboxStyle(
                            markVariant: .indeterminate, sizeVariant: sizeVariant, isHover: true))
            }
        }

        // Focused state row
        HStack(spacing: 48) {
            ForEach(sizeVariants, id: \.self) { sizeVariant in
                Toggle("", isOn: $isOn)
                    .toggleStyle(
                        CheckboxStyle(sizeVariant: sizeVariant, isHover: true, isFocused: true))
            }
        }

        // Indeterminate + Focused state row
        HStack(spacing: 48) {
            ForEach(sizeVariants, id: \.self) { sizeVariant in
                Toggle("", isOn: $isOn)
                    .toggleStyle(
                        CheckboxStyle(
                            markVariant: .indeterminate, sizeVariant: sizeVariant, isHover: true,
                            isFocused: true))
            }
        }

        // Error state row
        HStack(spacing: 48) {
            ForEach(sizeVariants, id: \.self) { sizeVariant in
                Toggle("", isOn: $isOn)
                    .toggleStyle(CheckboxStyle(typeVariant: .error, sizeVariant: sizeVariant))
            }
        }

        // Error + Hovered state row
        HStack(spacing: 48) {
            ForEach(sizeVariants, id: \.self) { sizeVariant in
                Toggle("", isOn: $isOn)
                    .toggleStyle(
                        CheckboxStyle(typeVariant: .error, sizeVariant: sizeVariant, isHover: true))
            }
        }

        // Error + Indeterminate state row
        HStack(spacing: 48) {
            ForEach(sizeVariants, id: \.self) { sizeVariant in
                Toggle("", isOn: $isOn)
                    .toggleStyle(
                        CheckboxStyle(
                            typeVariant: .error, markVariant: .indeterminate,
                            sizeVariant: sizeVariant))
            }
        }

        // Disabled state row
        HStack(spacing: 48) {
            ForEach(sizeVariants, id: \.self) { sizeVariant in
                Toggle("", isOn: $isOn)
                    .toggleStyle(CheckboxStyle(typeVariant: .disabled, sizeVariant: sizeVariant))
            }
        }

        // Disabled + Indeterminate state row
        HStack(spacing: 48) {
            ForEach(sizeVariants, id: \.self) { sizeVariant in
                Toggle("", isOn: $isOn)
                    .toggleStyle(
                        CheckboxStyle(
                            typeVariant: .disabled, markVariant: .indeterminate,
                            sizeVariant: sizeVariant))
            }
        }
    }
    .padding()
}
