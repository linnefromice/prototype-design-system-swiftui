import SwiftUI

public struct SelectBox<T: Hashable>: View {
    @Binding var selection: T
    let options: [T]
    let placeholder: String
    let optionLabel: (T) -> String
    let isFocused: Bool
    let isDisabled: Bool
    let error: String?

    public init(
        selection: Binding<T>,
        options: [T],
        placeholder: String = "選択してください",
        optionLabel: @escaping (T) -> String = { String(describing: $0) },
        isFocused: Bool = false,
        isDisabled: Bool = false,
        error: String? = nil
    ) {
        self._selection = selection
        self.options = options
        self.placeholder = placeholder
        self.optionLabel = optionLabel
        self.isFocused = isFocused
        self.isDisabled = isDisabled
        self.error = error
    }

    var hasError: Bool {
        error != nil
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Menu {
                ForEach(options, id: \.self) { option in
                    Button {
                        if !isDisabled {
                            selection = option
                        }
                    } label: {
                        Text(optionLabel(option))
                    }
                }
            } label: {
                HStack {
                    Text(optionLabel(selection))
                        .foregroundColor(
                            isDisabled
                                ? AppColor.Neutral.SolidGray.solidGray420
                                : AppColor.Neutral.SolidGray.solidGray900
                        )

                    Spacer()

                    Image(systemName: "chevron.down")
                        .foregroundColor(
                            hasError
                                ? AppColor.Semantic.Error.error1
                                : isDisabled
                                    ? AppColor.Neutral.SolidGray.solidGray420
                                    : AppColor.Neutral.SolidGray.solidGray600
                        )
                }
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

                        if isFocused && !isDisabled {
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
            .disabled(isDisabled)
            .accessibilityLabel(placeholder)
            .accessibilityValue(optionLabel(selection))
            .accessibilityHint(error ?? "")

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
    @Previewable @State var selectedOption1 = "オプション1"
    @Previewable @State var selectedOption2 = "オプション1"
    @Previewable @State var selectedOption3 = "オプション1"

    let options = ["オプション1", "オプション2", "オプション3", "オプション4"]

    ScrollView(.horizontal, showsIndicators: true) {
        VStack(spacing: 40) {
            VStack(spacing: 24) {
                HStack(spacing: 20) {
                    Text("Default")
                        .frame(width: 100, alignment: .trailing)
                        .font(.caption)

                    SelectBox(
                        selection: $selectedOption1,
                        options: options,
                        placeholder: "選択してください"
                    )
                    .frame(width: 200)

                    SelectBox(
                        selection: $selectedOption2,
                        options: options,
                        placeholder: "選択してください"
                    )
                    .frame(width: 300)

                    SelectBox(
                        selection: $selectedOption3,
                        options: options,
                        placeholder: "選択してください"
                    )
                    .frame(width: 150)
                }

                HStack(spacing: 20) {
                    Text("Default : hover")
                        .frame(width: 100, alignment: .trailing)
                        .font(.caption)

                    SelectBox(
                        selection: $selectedOption1,
                        options: options,
                        placeholder: "選択してください"
                    )
                    .frame(width: 200)

                    SelectBox(
                        selection: $selectedOption2,
                        options: options,
                        placeholder: "選択してください"
                    )
                    .frame(width: 300)

                    SelectBox(
                        selection: $selectedOption3,
                        options: options,
                        placeholder: "選択してください"
                    )
                    .frame(width: 150)
                }

                HStack(spacing: 20) {
                    Text("Default : focus")
                        .frame(width: 100, alignment: .trailing)
                        .font(.caption)

                    SelectBox(
                        selection: $selectedOption1,
                        options: options,
                        placeholder: "選択してください",
                        isFocused: true
                    )
                    .frame(width: 200)

                    SelectBox(
                        selection: $selectedOption2,
                        options: options,
                        placeholder: "選択してください",
                        isFocused: true
                    )
                    .frame(width: 300)

                    SelectBox(
                        selection: $selectedOption3,
                        options: options,
                        placeholder: "選択してください",
                        isFocused: true
                    )
                    .frame(width: 150)
                }

                HStack(alignment: .top, spacing: 20) {
                    Text("Error")
                        .frame(width: 100, alignment: .trailing)
                        .font(.caption)

                    SelectBox(
                        selection: $selectedOption1,
                        options: options,
                        placeholder: "選択してください",
                        error: "エラーテキストが入ります。"
                    )
                    .frame(width: 200)

                    SelectBox(
                        selection: $selectedOption2,
                        options: options,
                        placeholder: "選択してください",
                        error: "エラーテキストが入ります。"
                    )
                    .frame(width: 300)

                    SelectBox(
                        selection: $selectedOption3,
                        options: options,
                        placeholder: "選択してください",
                        error: "エラーテキストが入ります。"
                    )
                    .frame(width: 150)
                }

                HStack(alignment: .top, spacing: 20) {
                    Text("Error : hover")
                        .frame(width: 100, alignment: .trailing)
                        .font(.caption)

                    SelectBox(
                        selection: $selectedOption1,
                        options: options,
                        placeholder: "選択してください",
                        error: "エラーテキストが入ります。"
                    )
                    .frame(width: 200)

                    SelectBox(
                        selection: $selectedOption2,
                        options: options,
                        placeholder: "選択してください",
                        error: "エラーテキストが入ります。"
                    )
                    .frame(width: 300)

                    SelectBox(
                        selection: $selectedOption3,
                        options: options,
                        placeholder: "選択してください",
                        error: "エラーテキストが入ります。"
                    )
                    .frame(width: 150)
                }

                HStack(alignment: .top, spacing: 20) {
                    Text("Error : focus")
                        .frame(width: 100, alignment: .trailing)
                        .font(.caption)

                    SelectBox(
                        selection: $selectedOption1,
                        options: options,
                        placeholder: "選択してください",
                        isFocused: true,
                        error: "エラーテキストが入ります。"
                    )
                    .frame(width: 200)

                    SelectBox(
                        selection: $selectedOption2,
                        options: options,
                        placeholder: "選択してください",
                        isFocused: true,
                        error: "エラーテキストが入ります。"
                    )
                    .frame(width: 300)

                    SelectBox(
                        selection: $selectedOption3,
                        options: options,
                        placeholder: "選択してください",
                        isFocused: true,
                        error: "エラーテキストが入ります。"
                    )
                    .frame(width: 150)
                }

                HStack(spacing: 20) {
                    Text("Disabled")
                        .frame(width: 100, alignment: .trailing)
                        .font(.caption)

                    SelectBox(
                        selection: $selectedOption1,
                        options: options,
                        placeholder: "選択してください",
                        isDisabled: true
                    )
                    .frame(width: 200)

                    SelectBox(
                        selection: $selectedOption2,
                        options: options,
                        placeholder: "選択してください",
                        isDisabled: true
                    )
                    .frame(width: 300)

                    SelectBox(
                        selection: $selectedOption3,
                        options: options,
                        placeholder: "選択してください",
                        isDisabled: true
                    )
                    .frame(width: 150)
                }

                HStack(spacing: 20) {
                    Text("Disabled : focus")
                        .frame(width: 100, alignment: .trailing)
                        .font(.caption)

                    SelectBox(
                        selection: $selectedOption1,
                        options: options,
                        placeholder: "選択してください",
                        isFocused: true,
                        isDisabled: true
                    )
                    .frame(width: 200)

                    SelectBox(
                        selection: $selectedOption2,
                        options: options,
                        placeholder: "選択してください",
                        isFocused: true,
                        isDisabled: true
                    )
                    .frame(width: 300)

                    SelectBox(
                        selection: $selectedOption3,
                        options: options,
                        placeholder: "選択してください",
                        isFocused: true,
                        isDisabled: true
                    )
                    .frame(width: 150)
                }
            }
            .padding()
        }
    }
}
