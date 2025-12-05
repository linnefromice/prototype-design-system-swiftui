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

#Preview("SelectBox - Default") {
    @Previewable @State var selectedOption1 = "オプション1"
    @Previewable @State var selectedOption2 = "オプション1"
    @Previewable @State var selectedOption3 = "オプション1"

    let options = ["オプション1", "オプション2", "オプション3", "オプション4"]

    VStack(alignment: .leading, spacing: 24) {
        Text("SelectBox - Default").font(.title2.bold())

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 200").font(.caption).foregroundColor(.secondary)
            SelectBox(selection: $selectedOption1, options: options, placeholder: "選択してください").frame(width: 200)
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 300").font(.caption).foregroundColor(.secondary)
            SelectBox(selection: $selectedOption2, options: options, placeholder: "選択してください").frame(width: 300)
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 150").font(.caption).foregroundColor(.secondary)
            SelectBox(selection: $selectedOption3, options: options, placeholder: "選択してください").frame(width: 150)
        }
    }
    .padding()
}

#Preview("SelectBox - Focus") {
    @Previewable @State var selectedOption1 = "オプション1"
    @Previewable @State var selectedOption2 = "オプション1"
    @Previewable @State var selectedOption3 = "オプション1"

    let options = ["オプション1", "オプション2", "オプション3", "オプション4"]

    VStack(alignment: .leading, spacing: 24) {
        Text("SelectBox - Focus").font(.title2.bold())

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 200").font(.caption).foregroundColor(.secondary)
            SelectBox(selection: $selectedOption1, options: options, placeholder: "選択してください", isFocused: true).frame(width: 200)
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 300").font(.caption).foregroundColor(.secondary)
            SelectBox(selection: $selectedOption2, options: options, placeholder: "選択してください", isFocused: true).frame(width: 300)
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 150").font(.caption).foregroundColor(.secondary)
            SelectBox(selection: $selectedOption3, options: options, placeholder: "選択してください", isFocused: true).frame(width: 150)
        }
    }
    .padding()
}

#Preview("SelectBox - Error") {
    @Previewable @State var selectedOption1 = "オプション1"
    @Previewable @State var selectedOption2 = "オプション1"
    @Previewable @State var selectedOption3 = "オプション1"

    let options = ["オプション1", "オプション2", "オプション3", "オプション4"]

    VStack(alignment: .leading, spacing: 24) {
        Text("SelectBox - Error").font(.title2.bold())

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 200").font(.caption).foregroundColor(.secondary)
            SelectBox(selection: $selectedOption1, options: options, placeholder: "選択してください", error: "エラーテキストが入ります。").frame(width: 200)
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 300").font(.caption).foregroundColor(.secondary)
            SelectBox(selection: $selectedOption2, options: options, placeholder: "選択してください", error: "エラーテキストが入ります。").frame(width: 300)
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 150").font(.caption).foregroundColor(.secondary)
            SelectBox(selection: $selectedOption3, options: options, placeholder: "選択してください", error: "エラーテキストが入ります。").frame(width: 150)
        }

        Divider()
        Text("Error + Focus").font(.caption.bold())

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 200").font(.caption).foregroundColor(.secondary)
            SelectBox(selection: $selectedOption1, options: options, placeholder: "選択してください", isFocused: true, error: "エラーテキストが入ります。").frame(width: 200)
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 300").font(.caption).foregroundColor(.secondary)
            SelectBox(selection: $selectedOption2, options: options, placeholder: "選択してください", isFocused: true, error: "エラーテキストが入ります。").frame(width: 300)
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 150").font(.caption).foregroundColor(.secondary)
            SelectBox(selection: $selectedOption3, options: options, placeholder: "選択してください", isFocused: true, error: "エラーテキストが入ります。").frame(width: 150)
        }
    }
    .padding()
}

#Preview("SelectBox - Disabled") {
    @Previewable @State var selectedOption1 = "オプション1"
    @Previewable @State var selectedOption2 = "オプション1"
    @Previewable @State var selectedOption3 = "オプション1"

    let options = ["オプション1", "オプション2", "オプション3", "オプション4"]

    VStack(alignment: .leading, spacing: 24) {
        Text("SelectBox - Disabled").font(.title2.bold())

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 200").font(.caption).foregroundColor(.secondary)
            SelectBox(selection: $selectedOption1, options: options, placeholder: "選択してください", isDisabled: true).frame(width: 200)
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 300").font(.caption).foregroundColor(.secondary)
            SelectBox(selection: $selectedOption2, options: options, placeholder: "選択してください", isDisabled: true).frame(width: 300)
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 150").font(.caption).foregroundColor(.secondary)
            SelectBox(selection: $selectedOption3, options: options, placeholder: "選択してください", isDisabled: true).frame(width: 150)
        }

        Divider()
        Text("Disabled + Focus").font(.caption.bold())

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 200").font(.caption).foregroundColor(.secondary)
            SelectBox(selection: $selectedOption1, options: options, placeholder: "選択してください", isFocused: true, isDisabled: true).frame(width: 200)
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 300").font(.caption).foregroundColor(.secondary)
            SelectBox(selection: $selectedOption2, options: options, placeholder: "選択してください", isFocused: true, isDisabled: true).frame(width: 300)
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 150").font(.caption).foregroundColor(.secondary)
            SelectBox(selection: $selectedOption3, options: options, placeholder: "選択してください", isFocused: true, isDisabled: true).frame(width: 150)
        }
    }
    .padding()
}
