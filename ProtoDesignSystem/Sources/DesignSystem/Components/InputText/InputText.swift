import SwiftUI

public struct InputText: View {
    @Binding var value: String
    let placeholder: String?
    let isFocused: Bool
    let error: String?

    public init(
        _ value: Binding<String>, placeholder: String? = nil, isFocused: Bool = false,
        error: String? = nil
    ) {
        self._value = value
        self.placeholder = placeholder
        self.isFocused = isFocused
        self.error = error
    }

    var hasError: Bool {
        error != nil
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
                        .stroke(
                            hasError
                                ? AppColor.Semantic.Error.error1
                                : AppColor.Neutral.SolidGray.solidGray600, lineWidth: 1)

                    if isFocused {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(AppColor.Primitive.Yellow.yellow300, lineWidth: 2)
                            .padding(-1)
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(AppColor.Neutral.black, lineWidth: 2)
                            .padding(-2)
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

        InputText(
            .constant("Sample Text"),
            isFocused: false,
            error: "Error"
        )
        .padding()

        InputText(
            .constant("Sample Text"),
            isFocused: true,
            error: "Error"
        )
        .padding()
    }
}
