import SwiftUI

struct DefaultButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color.Neutral.white)
        }
        .padding(16)
        .background(Color.Primitive.Blue.blue900)
        .clipShape(RoundedRectangle(cornerRadius: Size.BorderRadius.val8))
    }
}

#Preview {
    DefaultButton(title: "Hello", action: {})
}
