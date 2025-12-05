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

#Preview("InputText - Default") {
    VStack(alignment: .leading, spacing: 20) {
        Text("InputText - Default").font(.title2.bold())

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 200").font(.caption).foregroundColor(.secondary)
            InputText(.constant(""), placeholder: "プレースホルダー").frame(width: 200)
            InputText(.constant("入力テキスト"), placeholder: "プレースホルダー").frame(width: 200)
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 300").font(.caption).foregroundColor(.secondary)
            InputText(.constant(""), placeholder: "プレースホルダー").frame(width: 300)
            InputText(.constant("入力テキスト"), placeholder: "プレースホルダー").frame(width: 300)
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 150").font(.caption).foregroundColor(.secondary)
            InputText(.constant(""), placeholder: "プレースホルダー").frame(width: 150)
            InputText(.constant("入力テキスト"), placeholder: "プレースホルダー").frame(width: 150)
        }
    }
    .padding()
}

#Preview("InputText - Focus") {
    VStack(alignment: .leading, spacing: 20) {
        Text("InputText - Focus").font(.title2.bold())

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 200").font(.caption).foregroundColor(.secondary)
            InputText(.constant(""), placeholder: "プレースホルダー", isFocused: true).frame(width: 200)
            InputText(.constant("入力テキスト"), placeholder: "プレースホルダー", isFocused: true).frame(width: 200)
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 300").font(.caption).foregroundColor(.secondary)
            InputText(.constant(""), placeholder: "プレースホルダー", isFocused: true).frame(width: 300)
            InputText(.constant("入力テキスト"), placeholder: "プレースホルダー", isFocused: true).frame(width: 300)
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 150").font(.caption).foregroundColor(.secondary)
            InputText(.constant(""), placeholder: "プレースホルダー", isFocused: true).frame(width: 150)
            InputText(.constant("入力テキスト"), placeholder: "プレースホルダー", isFocused: true).frame(width: 150)
        }
    }
    .padding()
}

#Preview("InputText - Error") {
    VStack(alignment: .leading, spacing: 20) {
        Text("InputText - Error").font(.title2.bold())

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 200").font(.caption).foregroundColor(.secondary)
            InputText(.constant("誤った入力内容"), placeholder: "プレースホルダー", error: "エラーテキストが入ります。").frame(width: 200)
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 300").font(.caption).foregroundColor(.secondary)
            InputText(.constant("誤った入力内容"), placeholder: "プレースホルダー", error: "エラーテキストが入ります。").frame(width: 300)
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 150").font(.caption).foregroundColor(.secondary)
            InputText(.constant("誤った入力内容"), placeholder: "プレースホルダー", error: "エラーテキストが入ります。").frame(width: 150)
        }

        Divider()
        Text("Error + Focus").font(.caption.bold())

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 200").font(.caption).foregroundColor(.secondary)
            InputText(.constant("入力テキスト"), placeholder: "プレースホルダー", isFocused: true, error: "エラーテキストが入ります。").frame(width: 200)
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 300").font(.caption).foregroundColor(.secondary)
            InputText(.constant("入力テキスト"), placeholder: "プレースホルダー", isFocused: true, error: "エラーテキストが入ります。").frame(width: 300)
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 150").font(.caption).foregroundColor(.secondary)
            InputText(.constant("入力テキスト"), placeholder: "プレースホルダー", isFocused: true, error: "エラーテキストが入ります。").frame(width: 150)
        }
    }
    .padding()
}

#Preview("InputText - Disabled") {
    VStack(alignment: .leading, spacing: 20) {
        Text("InputText - Disabled").font(.title2.bold())

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 200").font(.caption).foregroundColor(.secondary)
            InputText(.constant("入力テキスト"), placeholder: "プレースホルダー", isDisabled: true).frame(width: 200)
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 300").font(.caption).foregroundColor(.secondary)
            InputText(.constant("入力テキスト"), placeholder: "プレースホルダー", isDisabled: true).frame(width: 300)
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 150").font(.caption).foregroundColor(.secondary)
            InputText(.constant("入力テキスト"), placeholder: "プレースホルダー", isDisabled: true).frame(width: 150)
        }

        Divider()
        Text("Disabled + Focus").font(.caption.bold())

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 200").font(.caption).foregroundColor(.secondary)
            InputText(.constant("入力テキスト"), placeholder: "プレースホルダー", isFocused: true, isDisabled: true).frame(width: 200)
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 300").font(.caption).foregroundColor(.secondary)
            InputText(.constant("入力テキスト"), placeholder: "プレースホルダー", isFocused: true, isDisabled: true).frame(width: 300)
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("Width: 150").font(.caption).foregroundColor(.secondary)
            InputText(.constant("入力テキスト"), placeholder: "プレースホルダー", isFocused: true, isDisabled: true).frame(width: 150)
        }
    }
    .padding()
}
