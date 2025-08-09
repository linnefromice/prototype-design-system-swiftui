import SwiftUI

private struct TextButtonStyle {
    let variant: ButtonTypeVariant
    let isFocused: Bool

    var foregroundColor: SwiftUI.Color {
        switch variant {
        case ._default: return AppColor.Primitive.Blue.blue900
        case .hover: return AppColor.Primitive.Blue.blue1000
        case .active: return AppColor.Primitive.Blue.blue1200
        case .disabled: return AppColor.Neutral.SolidGray.solidGray300
        }
    }

    var backgroundColor: SwiftUI.Color {
        if isFocused {
            return AppColor.Primitive.Yellow.yellow300
        }

        switch variant {
        case ._default: return .clear
        case .hover: return AppColor.Primitive.Blue.blue50
        case .active: return AppColor.Primitive.Blue.blue100
        case .disabled: return .clear
        }
    }

    var underlineHeight: CGFloat {
        switch variant {
        case ._default: return 1
        case .hover: return 2
        case .active: return 2
        case .disabled: return 1
        }
    }
}

struct TextButton: View {
    let title: String
    let action: () -> Void
    fileprivate let style: TextButtonStyle
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
        self.style = TextButtonStyle(variant: typeVariant, isFocused: isFocused)
        self.sizeVariant = sizeVariant
        self.isFocused = isFocused
    }

    var body: some View {
        Button(action: action) {
            Group {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    // .underline(pattern: .solid, color: style.foregroundColor)
                    .foregroundColor(style.foregroundColor)
                    .background(
                        GeometryReader { geometry in
                            Rectangle()
                                .fill(style.foregroundColor)
                                .frame(width: geometry.size.width, height: style.underlineHeight)
                                .offset(y: geometry.size.height)
                        }
                    )
            }
            .padding(.horizontal, sizeVariant.xPadding)
            .padding(.vertical, sizeVariant.yPadding)
            .background(style.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: Size.BorderRadius.val8))
            .overlay(
                Group {
                    if isFocused {
                        RoundedRectangle(cornerRadius: Size.BorderRadius.val8)
                            .stroke(AppColor.Neutral.black, lineWidth: 4)
                    }
                }
            )

        }
        .buttonStyle(PlainButtonStyle())
        .padding(isFocused ? 4 : 0)
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
                                TextButton(
                                    title: "Normal",
                                    action: {},
                                    typeVariant: typeVariant,
                                    sizeVariant: sizeVariant,
                                    isFocused: false
                                )
                                Spacer()
                            }
                            HStack {
                                TextButton(
                                    title: "Focused",
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
