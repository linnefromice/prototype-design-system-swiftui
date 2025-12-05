import SwiftUI

private struct SolidFillButtonStyle {
    let variant: ButtonTypeVariant

    var backgroundColor: SwiftUI.Color {
        switch self.variant {
        case ._default: return AppColor.Primitive.Blue.blue900
        case .hover: return AppColor.Primitive.Blue.blue1000
        case .active: return AppColor.Primitive.Blue.blue1200
        case .disabled: return AppColor.Primitive.Blue.blue300
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

struct SolidFillButton: View {
    let title: String
    let action: () -> Void
    fileprivate let style: SolidFillButtonStyle
    let sizeVariant: ButtonSizeVariant
    let isFocused: Bool

    init(
        title: String,
        action: @escaping () -> Void,
        typeVariant: ButtonTypeVariant,
        sizeVariant: ButtonSizeVariant,
        isFocused: Bool = false
    ) {
        self.title = title
        self.action = action
        self.style = SolidFillButtonStyle(variant: typeVariant)
        self.sizeVariant = sizeVariant
        self.isFocused = isFocused
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .underline(style.withUnderline)
                .foregroundColor(AppColor.Neutral.white)
                .padding(.horizontal, sizeVariant.xPadding)
                .padding(.vertical, sizeVariant.yPadding)
                .background(style.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: Size.BorderRadius.val8))
                .overlay(
                    ZStack {
                        // Outer Black Border
                        RoundedRectangle(cornerRadius: Size.BorderRadius.val8)
                            .stroke(isFocused ? AppColor.Neutral.black : Color.clear, lineWidth: 4)
                        // Inner Yellow Border
                        RoundedRectangle(cornerRadius: Size.BorderRadius.val8)
                            .stroke(
                                isFocused ? AppColor.Primitive.Yellow.yellow300 : Color.clear,
                                lineWidth: 2
                            )
                            .padding(2)
                    }
                )
        }
        .buttonStyle(PlainButtonStyle())
        .padding(4)
    }
}

#Preview("SolidFillButton - Small") {
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
                        SolidFillButton(
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
                        SolidFillButton(
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

#Preview("SolidFillButton - Medium") {
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
                        SolidFillButton(
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
                        SolidFillButton(
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

#Preview("SolidFillButton - Large") {
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
                        SolidFillButton(
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
                        SolidFillButton(
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
