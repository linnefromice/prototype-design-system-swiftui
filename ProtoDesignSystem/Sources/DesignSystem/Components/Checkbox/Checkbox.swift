import SwiftUI

public enum CheckboxTypeVariant {
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
    let sizeVariant: CheckboxSizeVariant
    let isHover: Bool

    init(
        typeVariant: CheckboxTypeVariant = ._default,
        sizeVariant: CheckboxSizeVariant = .md,
        isHover: Bool = false
    ) {
        self.typeVariant = typeVariant
        self.sizeVariant = sizeVariant
        self.isHover = isHover
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

                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                configuration.isOn
                                    ? AppColor.Primitive.Blue.blue600 : AppColor.Neutral.white
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(AppColor.Neutral.SolidGray.solidGray400, lineWidth: 1)
                            )

                        if configuration.isOn {
                            typeVariant.image(baseSize: sizeVariant.size)
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
}

extension ToggleStyle where Self == CheckboxStyle {
    public static var customCheckbox: CheckboxStyle {
        CheckboxStyle()
    }
}

#Preview {
    @Previewable @State var isOn: Bool = false

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
                        CheckboxStyle(typeVariant: .indeterminate, sizeVariant: sizeVariant))
            }
        }

        // Indeterminate + Hovered state row
        HStack(spacing: 48) {
            ForEach(sizeVariants, id: \.self) { sizeVariant in
                Toggle("", isOn: $isOn)
                    .toggleStyle(
                        CheckboxStyle(
                            typeVariant: .indeterminate, sizeVariant: sizeVariant, isHover: true))
            }
        }
    }
    .padding()
}
