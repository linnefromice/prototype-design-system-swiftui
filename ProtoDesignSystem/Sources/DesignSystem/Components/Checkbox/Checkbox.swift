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

#Preview("Checkbox - Small") {
    @Previewable @State var isOn: Bool = true

    VStack(alignment: .leading, spacing: 16) {
        Group {
            Text("Default").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(sizeVariant: .sm))
        }

        Group {
            Text("Hovered").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(sizeVariant: .sm, isHover: true))
        }

        Group {
            Text("Indeterminate").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(markVariant: .indeterminate, sizeVariant: .sm))
        }

        Group {
            Text("Indeterminate + Hovered").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(markVariant: .indeterminate, sizeVariant: .sm, isHover: true))
        }

        Group {
            Text("Focused").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(sizeVariant: .sm, isHover: true, isFocused: true))
        }

        Group {
            Text("Indeterminate + Focused").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(markVariant: .indeterminate, sizeVariant: .sm, isHover: true, isFocused: true))
        }

        Group {
            Text("Error").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(typeVariant: .error, sizeVariant: .sm))
        }

        Group {
            Text("Error + Hovered").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(typeVariant: .error, sizeVariant: .sm, isHover: true))
        }

        Group {
            Text("Error + Indeterminate").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(typeVariant: .error, markVariant: .indeterminate, sizeVariant: .sm))
        }

        Group {
            Text("Disabled").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(typeVariant: .disabled, sizeVariant: .sm))
        }

        Group {
            Text("Disabled + Indeterminate").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(typeVariant: .disabled, markVariant: .indeterminate, sizeVariant: .sm))
        }
    }
    .padding()
}

#Preview("Checkbox - Medium") {
    @Previewable @State var isOn: Bool = true

    VStack(alignment: .leading, spacing: 16) {
        Group {
            Text("Default").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(sizeVariant: .md))
        }

        Group {
            Text("Hovered").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(sizeVariant: .md, isHover: true))
        }

        Group {
            Text("Indeterminate").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(markVariant: .indeterminate, sizeVariant: .md))
        }

        Group {
            Text("Indeterminate + Hovered").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(markVariant: .indeterminate, sizeVariant: .md, isHover: true))
        }

        Group {
            Text("Focused").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(sizeVariant: .md, isHover: true, isFocused: true))
        }

        Group {
            Text("Indeterminate + Focused").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(markVariant: .indeterminate, sizeVariant: .md, isHover: true, isFocused: true))
        }

        Group {
            Text("Error").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(typeVariant: .error, sizeVariant: .md))
        }

        Group {
            Text("Error + Hovered").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(typeVariant: .error, sizeVariant: .md, isHover: true))
        }

        Group {
            Text("Error + Indeterminate").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(typeVariant: .error, markVariant: .indeterminate, sizeVariant: .md))
        }

        Group {
            Text("Disabled").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(typeVariant: .disabled, sizeVariant: .md))
        }

        Group {
            Text("Disabled + Indeterminate").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(typeVariant: .disabled, markVariant: .indeterminate, sizeVariant: .md))
        }
    }
    .padding()
}

#Preview("Checkbox - Large") {
    @Previewable @State var isOn: Bool = true

    VStack(alignment: .leading, spacing: 16) {
        Group {
            Text("Default").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(sizeVariant: .lg))
        }

        Group {
            Text("Hovered").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(sizeVariant: .lg, isHover: true))
        }

        Group {
            Text("Indeterminate").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(markVariant: .indeterminate, sizeVariant: .lg))
        }

        Group {
            Text("Indeterminate + Hovered").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(markVariant: .indeterminate, sizeVariant: .lg, isHover: true))
        }

        Group {
            Text("Focused").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(sizeVariant: .lg, isHover: true, isFocused: true))
        }

        Group {
            Text("Indeterminate + Focused").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(markVariant: .indeterminate, sizeVariant: .lg, isHover: true, isFocused: true))
        }

        Group {
            Text("Error").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(typeVariant: .error, sizeVariant: .lg))
        }

        Group {
            Text("Error + Hovered").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(typeVariant: .error, sizeVariant: .lg, isHover: true))
        }

        Group {
            Text("Error + Indeterminate").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(typeVariant: .error, markVariant: .indeterminate, sizeVariant: .lg))
        }

        Group {
            Text("Disabled").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(typeVariant: .disabled, sizeVariant: .lg))
        }

        Group {
            Text("Disabled + Indeterminate").font(.caption).foregroundColor(.secondary)
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxStyle(typeVariant: .disabled, markVariant: .indeterminate, sizeVariant: .lg))
        }
    }
    .padding()
}
