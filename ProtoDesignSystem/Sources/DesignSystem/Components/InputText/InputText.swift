import SwiftUI

public struct InputText: View {
    @Binding var value: String
    let placeholder: String?

    public init(_ value: Binding<String>, placeholder: String? = nil) {
        self._value = value
        self.placeholder = placeholder
    }

    public var body: some View {
        TextField(placeholder.map { $0 } ?? "", text: $value)
            .textFieldStyle(PlainTextFieldStyle())
            .foregroundColor(AppColor.Neutral.SolidGray.solidGray900)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .border(AppColor.Neutral.SolidGray.solidGray600, width: 1)
            .cornerRadius(8)
    }
}

#Preview {
    VStack(spacing: 32) {
        InputText(
            .constant("Sample Text")
        )
        .padding()

        InputText(
            .constant("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
        )
        .padding()
    }
}