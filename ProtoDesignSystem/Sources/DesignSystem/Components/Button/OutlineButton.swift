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
                        // Outer Black Border
                        RoundedRectangle(cornerRadius: Size.BorderRadius.val8)
                            .stroke(isFocused ? AppColor.Neutral.black : Color.clear, lineWidth: 6)
                        // Inner Yellow Border
                        RoundedRectangle(cornerRadius: Size.BorderRadius.val8)
                            .stroke(
                                isFocused ? AppColor.Primitive.Yellow.yellow300 : Color.clear,
                                lineWidth: 4
                            )
                            .padding(2)
                        // TODO
                        // // Base Border
                        // RoundedRectangle(cornerRadius: Size.BorderRadius.val8)
                        //     .stroke(style.borderColor, lineWidth: 2)
                        //     .padding(4)
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
                                OutlineButton(
                                    title: "Hello, World!",
                                    action: {},
                                    typeVariant: typeVariant,
                                    sizeVariant: sizeVariant,
                                    isFocused: false
                                )
                                Spacer()
                            }
                            HStack {
                                OutlineButton(
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
}
