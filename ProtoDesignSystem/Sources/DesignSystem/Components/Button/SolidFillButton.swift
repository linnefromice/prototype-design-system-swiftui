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

#Preview {
    ScrollView {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
            ForEach(ButtonTypeVariant.allCases, id: \.self) { typeVariant in
                VStack(alignment: .leading, spacing: 10) {
                    Text(String(describing: typeVariant))
                        .font(.headline)
                        .foregroundColor(.primary)

                    ForEach(ButtonSizeVariant.allCases, id: \.self) { sizeVariant in
                        VStack(spacing: 8) {
                            HStack {
                                SolidFillButton(
                                    title: "Hello, World!",
                                    action: {},
                                    typeVariant: typeVariant,
                                    sizeVariant: sizeVariant,
                                    isFocused: false
                                )
                                Spacer()
                            }
                            HStack {
                                SolidFillButton(
                                    title: "Hello, World!",
                                    action: {},
                                    typeVariant: typeVariant,
                                    sizeVariant: sizeVariant,
                                    isFocused: true
                                )
                                Spacer()
                            }
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
    }
    .preferredColorScheme(.light)
}
