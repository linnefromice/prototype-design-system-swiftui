import SwiftUI

struct SolidFillButton: View {
    let title: String
    let action: () -> Void
    let typeVariant: ButtonTypeVariant
    let sizeVariant: ButtonSizeVariant
    let isFocused: Bool

    init(title: String, action: @escaping () -> Void, typeVariant: ButtonTypeVariant, sizeVariant: ButtonSizeVariant, isFocused: Bool = false) {
        self.title = title
        self.action = action
        self.typeVariant = typeVariant
        self.sizeVariant = sizeVariant
        self.isFocused = isFocused
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .underline(typeVariant.withUnderline)
                .foregroundColor(AppColor.Neutral.white)
                .padding(.horizontal, sizeVariant.xPadding)
                .padding(.vertical, sizeVariant.yPadding)
                .background(typeVariant.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: Size.BorderRadius.val8))
                .overlay(
                    ZStack {
                        // Outer Black Border
                        RoundedRectangle(cornerRadius: Size.BorderRadius.val8)
                            .stroke(isFocused ? AppColor.Neutral.black : Color.clear, lineWidth: 4)
                        // Inner Yellow Border
                        RoundedRectangle(cornerRadius: Size.BorderRadius.val8)
                            .stroke(isFocused ? AppColor.Primitive.Yellow.yellow300 : Color.clear, lineWidth: 2)
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
}
