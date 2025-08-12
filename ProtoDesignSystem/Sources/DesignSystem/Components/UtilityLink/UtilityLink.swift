import SwiftUI

struct UtilityLink: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "rectangle.grid.3x3.fill")
                    .foregroundColor(AppColor.Neutral.SolidGray.solidGray900)
                    .frame(width: 16, height: 16)

                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .underline(true, pattern: .solid)
                    .foregroundColor(AppColor.Neutral.SolidGray.solidGray800)

                Image(systemName: "rectangle.dashed.and.paperclip")
                    .foregroundColor(AppColor.Neutral.SolidGray.solidGray900)
                    .frame(width: 16, height: 16)
            }
        }
    }
}

#Preview {
    UtilityLink(title: "Preview", action: {})
}
