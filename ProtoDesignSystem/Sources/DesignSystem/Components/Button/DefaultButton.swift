import SwiftUI

struct Constants {
    static let ColorPrimitiveBlue900: Color = Color(red: 0, green: 0.09, blue: 0.76)
    static let BorderRadius8: CGFloat = 8
}

struct DefaultButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 4) {
                Text(title)
                    .foregroundColor(.white)
            }
            .padding(16)
            .background(Constants.ColorPrimitiveBlue900)
            .cornerRadius(Constants.BorderRadius8)
        }
    }
}

#Preview {
    DefaultButton(title: "Hello", action: {})
}
