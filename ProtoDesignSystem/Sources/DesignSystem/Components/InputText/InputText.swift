import SwiftUI

public struct InputText: View {
    @Binding var value: String
    let placeholder: String?
    let isFocused: Bool
    let isDisabled: Bool
    let error: String?

    public init(
        _ value: Binding<String>, placeholder: String? = nil, isFocused: Bool = false,
        isDisabled: Bool = false,
        error: String? = nil
    ) {
        self._value = value
        self.placeholder = placeholder
        self.isFocused = isFocused
        self.isDisabled = isDisabled
        self.error = error
    }

    var hasError: Bool {
        error != nil
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TextField(placeholder.map { $0 } ?? "", text: $value)
                .disabled(isDisabled)
                .foregroundColor(
                    isDisabled
                        ? AppColor.Neutral.SolidGray.solidGray420
                        : AppColor.Neutral.SolidGray.solidGray900
                )
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(
                    ZStack {
                        if isDisabled {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(AppColor.Neutral.SolidGray.solidGray50)
                        }

                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                hasError
                                    ? AppColor.Semantic.Error.error1
                                    : isDisabled
                                        ? AppColor.Neutral.SolidGray.solidGray300
                                        : AppColor.Neutral.SolidGray.solidGray600,
                                lineWidth: 1)

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

            if let errorMessage = error {
                Spacer().frame(height: 8)
                Text("* \(errorMessage)")
                    .font(.system(size: 16))
                    .foregroundColor(AppColor.Semantic.Error.error1)
            }
        }
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

        InputText(
            .constant("Sample Text"),
            isDisabled: true
        )
        .padding()

        InputText(
            .constant("Sample Text"),
            isFocused: true,
            isDisabled: true
        )
        .padding()
    }
}
