import SwiftUI

struct UtilityLink: View {
    let title: String
    let action: () -> Void
    let isHover: Bool

    init(
        title: String,
        action: @escaping () -> Void,
        isHover: Bool = false
    ) {
        self.title = title
        self.action = action
        self.isHover = isHover
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "rectangle.grid.3x3.fill")
                    .foregroundColor(AppColor.Neutral.SolidGray.solidGray900)
                    .frame(width: 16, height: 16)

                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(AppColor.Neutral.SolidGray.solidGray800)
                    .background(
                        GeometryReader { geometry in
                            Rectangle()
                                .fill(AppColor.Neutral.SolidGray.solidGray800)
                                .frame(width: geometry.size.width, height: isHover ? 2 : 1)
                                .offset(y: geometry.size.height)
                        }
                    )

                Image(systemName: "rectangle.dashed.and.paperclip")
                    .foregroundColor(AppColor.Neutral.SolidGray.solidGray900)
                    .frame(width: 16, height: 16)
            }
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        UtilityLink(title: "Preview", action: {})
        UtilityLink(title: "is hover", action: {}, isHover: true)
    }
}
