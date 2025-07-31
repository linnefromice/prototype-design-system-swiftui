import SwiftUI

struct DefaultButton: View {
    let title: String
    let action: () -> Void
    let sizeVariant: ButtonSizeVariant
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color.Neutral.white)
        }
        .padding(.horizontal, sizeVariant.xPadding)
        .padding(.vertical, sizeVariant.yPadding)
        .background(Color.Primitive.Blue.blue900)
        .clipShape(RoundedRectangle(cornerRadius: Size.BorderRadius.val8))
    }
}

#Preview {
    VStack {
        ForEach(ButtonSizeVariant.allCases, id: \.self) { sizeVariant in
            DefaultButton(title: "Hello", action: {}, sizeVariant: sizeVariant)
        }
    }
}
