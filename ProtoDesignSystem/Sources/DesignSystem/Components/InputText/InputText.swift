import SwiftUI

public struct InputTextStyle {
    let isFocused: Bool

    init(isFocused: Bool) {
        self.isFocused = isFocused
    }

    var innerBorderColor: SwiftUI.Color {
        if isFocused {
            return AppColor.Primitive.Yellow.yellow300
        }
        return AppColor.Neutral.SolidGray.solidGray600
    }

    var outerBorderColor: SwiftUI.Color? {
        if isFocused {
            return AppColor.Neutral.black
        }
        return nil
    }
}

public struct InputText: View {
    @Binding var value: String
    let placeholder: String?
    let style: InputTextStyle

    public init(_ value: Binding<String>, placeholder: String? = nil, isFocused: Bool = false) {
        self._value = value
        self.placeholder = placeholder
        self.style = InputTextStyle(isFocused: isFocused)
    }

    public var body: some View {
        TextField(placeholder.map { $0 } ?? "", text: $value)
            // .textFieldStyle(PlainTextFieldStyle())
            .foregroundColor(AppColor.Neutral.SolidGray.solidGray900)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            // .border(AppColor.Neutral.SolidGray.solidGray600, width: 1)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(style.innerBorderColor, lineWidth: 1)
                    if let outerBorderColor = style.outerBorderColor {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(outerBorderColor, lineWidth: 2)
                            .padding(-1)
                    }
                }
            )
    }
}

#Preview {
    VStack(spacing: 32) {
        InputText(
            .constant("Sample Text"),
            isFocused: false
        )
        .padding()

        InputText(
            .constant(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
            ),
            isFocused: true
        )
        .padding()
    }
}
