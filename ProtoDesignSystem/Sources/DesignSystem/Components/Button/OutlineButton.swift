import SwiftUI

private struct OutlineButtonStyle {
    let variant: ButtonTypeVariant

    var foregroundColor: SwiftUI.Color {
        switch self.variant {
        case ._default: return AppColor.Primitive.Blue.blue900
        case .hover: return AppColor.Primitive.Blue.blue1000
        case .active: return AppColor.Primitive.Blue.blue1200
        case .disabled: return AppColor.Neutral.SolidGray.solidGray300
        }
    }

    var backgroundColor: SwiftUI.Color {
        switch self.variant {
        case ._default: return AppColor.Neutral.white
        case .hover: return AppColor.Primitive.Blue.blue200
        case .active: return AppColor.Primitive.Blue.blue300
        case .disabled: return AppColor.Neutral.white
        }
    }

    var borderColor: SwiftUI.Color {
        switch self.variant {
        case ._default: return AppColor.Primitive.Blue.blue900
        case .hover: return AppColor.Primitive.Blue.blue1000
        case .active: return AppColor.Primitive.Blue.blue1200
        case .disabled: return AppColor.Neutral.SolidGray.solidGray300
        }
    }

    var withUnderline: Bool {
        switch self.variant {
        case ._default: return false
        case .hover: return true
        case .active: return true
        case .disabled: return false
        }
    }
}

struct OutlineButton: View {
    let title: String
    let action: () -> Void
    fileprivate let style: OutlineButtonStyle
    let sizeVariant: ButtonSizeVariant
    let isFocused: Bool

    init(
        title: String, action: @escaping () -> Void, typeVariant: ButtonTypeVariant,
        sizeVariant: ButtonSizeVariant,
        isFocused: Bool = false
    ) {
        self.title = title
        self.action = action
        self.style = OutlineButtonStyle(variant: typeVariant)
        self.sizeVariant = sizeVariant
        self.isFocused = isFocused
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .underline(style.withUnderline)
                .foregroundColor(style.foregroundColor)
                .padding(.horizontal, sizeVariant.xPadding)
                .padding(.vertical, sizeVariant.yPadding)
                .background(style.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: Size.BorderRadius.val8))
                .overlay(
                    ZStack {
                        // Base Border (always visible)
                        RoundedRectangle(cornerRadius: Size.BorderRadius.val8)
                            .stroke(style.borderColor, lineWidth: 2)

                        // Focus borders (only when focused)
                        if isFocused {
                            // Outer Black Border
                            RoundedRectangle(cornerRadius: Size.BorderRadius.val8)
                                .stroke(AppColor.Neutral.black, lineWidth: 4)
                                .padding(-2)
                            // Inner Yellow Border
                            RoundedRectangle(cornerRadius: Size.BorderRadius.val8)
                                .stroke(AppColor.Primitive.Yellow.yellow300, lineWidth: 2)
                                .padding(-1)
                        }
                    }
                )
        }
        .buttonStyle(PlainButtonStyle())
        .padding(4)
    }
}

#Preview("OutlineButton - Small") {
    VStack(alignment: .leading, spacing: 16) {
        ForEach(ButtonTypeVariant.allCases, id: \.self) { typeVariant in
            VStack(alignment: .leading, spacing: 8) {
                Text(String(describing: typeVariant))
                    .font(.caption)
                    .foregroundColor(.secondary)

                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Default")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        OutlineButton(
                            title: "Hello, World!",
                            action: {},
                            typeVariant: typeVariant,
                            sizeVariant: .small,
                            isFocused: false
                        )
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Focused")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        OutlineButton(
                            title: "Hello, World!",
                            action: {},
                            typeVariant: typeVariant,
                            sizeVariant: .small,
                            isFocused: true
                        )
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(8)
        }
    }
    .padding()
    .preferredColorScheme(.light)
}

#Preview("OutlineButton - Medium") {
    VStack(alignment: .leading, spacing: 16) {
        ForEach(ButtonTypeVariant.allCases, id: \.self) { typeVariant in
            VStack(alignment: .leading, spacing: 8) {
                Text(String(describing: typeVariant))
                    .font(.caption)
                    .foregroundColor(.secondary)

                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Default")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        OutlineButton(
                            title: "Hello, World!",
                            action: {},
                            typeVariant: typeVariant,
                            sizeVariant: .medium,
                            isFocused: false
                        )
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Focused")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        OutlineButton(
                            title: "Hello, World!",
                            action: {},
                            typeVariant: typeVariant,
                            sizeVariant: .medium,
                            isFocused: true
                        )
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(8)
        }
    }
    .padding()
    .preferredColorScheme(.light)
}

#Preview("OutlineButton - Large") {
    VStack(alignment: .leading, spacing: 16) {
        ForEach(ButtonTypeVariant.allCases, id: \.self) { typeVariant in
            VStack(alignment: .leading, spacing: 8) {
                Text(String(describing: typeVariant))
                    .font(.caption)
                    .foregroundColor(.secondary)

                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Default")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        OutlineButton(
                            title: "Hello, World!",
                            action: {},
                            typeVariant: typeVariant,
                            sizeVariant: .large,
                            isFocused: false
                        )
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Focused")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        OutlineButton(
                            title: "Hello, World!",
                            action: {},
                            typeVariant: typeVariant,
                            sizeVariant: .large,
                            isFocused: true
                        )
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(8)
        }
    }
    .padding()
    .preferredColorScheme(.light)
}
