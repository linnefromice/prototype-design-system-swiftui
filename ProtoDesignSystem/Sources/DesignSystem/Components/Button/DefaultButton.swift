import SwiftUI

struct DefaultButton: View {
    let title: String
    let action: () -> Void
    let typeVariant: ButtonTypeVariant
    let sizeVariant: ButtonSizeVariant
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(AppColor.Neutral.white)
        }
        .padding(.horizontal, sizeVariant.xPadding)
        .padding(.vertical, sizeVariant.yPadding)
        .background(typeVariant.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: Size.BorderRadius.val8))
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
                        HStack {
                            DefaultButton(
                                title: "Hello, World!",
                                action: {},
                                typeVariant: typeVariant,
                                sizeVariant: sizeVariant
                            )
                            Spacer()
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
