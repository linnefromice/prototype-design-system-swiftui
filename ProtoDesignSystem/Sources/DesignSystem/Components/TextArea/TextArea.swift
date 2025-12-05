import SwiftUI

public struct TextArea: View {
    @Binding var value: String
    let placeholder: String?
    let maxLength: Int?
    let isFocused: Bool
    let isDisabled: Bool
    let isReadonly: Bool
    let error: String?

    public init(
        _ value: Binding<String>,
        placeholder: String? = nil,
        maxLength: Int? = nil,
        isFocused: Bool = false,
        isDisabled: Bool = false,
        isReadonly: Bool = false,
        error: String? = nil
    ) {
        self._value = value
        self.placeholder = placeholder
        self.maxLength = maxLength
        self.isFocused = isFocused
        self.isDisabled = isDisabled
        self.isReadonly = isReadonly
        self.error = error
    }

    var hasError: Bool {
        error != nil
    }

    var currentLength: Int {
        value.count
    }

    var isOverLimit: Bool {
        if let maxLength = maxLength {
            return currentLength > maxLength
        }
        return false
    }

    var counterColor: Color {
        if hasError || isOverLimit {
            return AppColor.Semantic.Error.error1
        }
        return AppColor.Neutral.SolidGray.solidGray600
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                // Background and border
                ZStack {
                    if isDisabled {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppColor.Neutral.SolidGray.solidGray50)
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppColor.Neutral.white)
                    }

                    // Border
                    if isReadonly {
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(
                                AppColor.Neutral.SolidGray.solidGray600,
                                style: StrokeStyle(lineWidth: 1, dash: [4, 4])
                            )
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                hasError
                                    ? AppColor.Semantic.Error.error1
                                    : isDisabled
                                        ? AppColor.Neutral.SolidGray.solidGray300
                                        : AppColor.Neutral.SolidGray.solidGray600,
                                lineWidth: 1
                            )
                    }

                    // Focus rings
                    if isFocused {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(AppColor.Primitive.Yellow.yellow300, lineWidth: 2)
                            .padding(-1)
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(AppColor.Neutral.black, lineWidth: 2)
                            .padding(-2)
                    }
                }

                // TextEditor with placeholder overlay
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $value)
                        .disabled(isDisabled || isReadonly)
                        .foregroundColor(
                            isDisabled
                                ? AppColor.Neutral.SolidGray.solidGray420
                                : AppColor.Neutral.SolidGray.solidGray900
                        )
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .padding(.bottom, 24) // Space for character counter

                    // Placeholder
                    if value.isEmpty, let placeholderText = placeholder {
                        Text(placeholderText)
                            .foregroundColor(AppColor.Neutral.SolidGray.solidGray420)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                            .allowsHitTesting(false)
                    }
                }

                // Character counter (bottom right)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        if let maxLength = maxLength {
                            Text("\(currentLength) / \(maxLength)")
                                .font(.system(size: 12))
                                .foregroundColor(counterColor)
                                .padding(.trailing, 12)
                                .padding(.bottom, 8)
                        } else {
                            Text("\(currentLength)")
                                .font(.system(size: 12))
                                .foregroundColor(counterColor)
                                .padding(.trailing, 12)
                                .padding(.bottom, 8)
                        }
                    }
                }
            }
            .frame(minHeight: 120)

            // Error message
            if let errorMessage = error {
                Spacer().frame(height: 8)
                Text("* \(errorMessage)")
                    .font(.system(size: 16))
                    .foregroundColor(AppColor.Semantic.Error.error1)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(placeholder ?? "テキストエリア")
        .accessibilityValue(value.isEmpty ? "空" : value)
        .accessibilityHint(
            isDisabled
                ? "無効"
                : isReadonly
                    ? "読み取り専用"
                    : hasError
                        ? "エラー: \(error ?? "")"
                        : maxLength.map { "最大\($0)文字" } ?? ""
        )
    }
}

#Preview("TextArea - Default") {
    VStack(alignment: .leading, spacing: 24) {
        Text("TextArea - Default").font(.title2.bold())

        VStack(alignment: .leading, spacing: 16) {
            Text("Empty").font(.caption).foregroundColor(.secondary)
            TextArea(.constant(""), placeholder: "プレースホルダー", maxLength: 100).frame(width: 300)
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("With content").font(.caption).foregroundColor(.secondary)
            TextArea(.constant("入力テキストです。"), placeholder: "プレースホルダー", maxLength: 100).frame(width: 300)
        }
    }
    .padding()
}

#Preview("TextArea - Focus") {
    VStack(alignment: .leading, spacing: 24) {
        Text("TextArea - Focus").font(.title2.bold())

        VStack(alignment: .leading, spacing: 16) {
            Text("Empty + Focus").font(.caption).foregroundColor(.secondary)
            TextArea(.constant(""), placeholder: "プレースホルダー", maxLength: 100, isFocused: true).frame(width: 300)
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("With content + Focus").font(.caption).foregroundColor(.secondary)
            TextArea(.constant("入力テキストです。"), placeholder: "プレースホルダー", maxLength: 100, isFocused: true).frame(width: 300)
        }
    }
    .padding()
}

#Preview("TextArea - Error") {
    VStack(alignment: .leading, spacing: 24) {
        Text("TextArea - Error").font(.title2.bold())

        VStack(alignment: .leading, spacing: 16) {
            Text("Error").font(.caption).foregroundColor(.secondary)
            TextArea(
                .constant("誤った入力内容です。誤った入力内容です。誤った入力内容です。誤った入力内容です。誤った入力内容です。誤った入力内容です。誤った入力内容です。誤った入力内容です。誤った入力内容です。誤った入力内容です。誤った"),
                placeholder: "プレースホルダー",
                maxLength: 100,
                error: "エラーテキストが入ります。"
            ).frame(width: 300)
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("Error + Focus").font(.caption).foregroundColor(.secondary)
            TextArea(
                .constant("誤った入力内容です。誤った入力内容です。"),
                placeholder: "プレースホルダー",
                maxLength: 100,
                isFocused: true,
                error: "エラーテキストが入ります。"
            ).frame(width: 300)
        }
    }
    .padding()
}

#Preview("TextArea - Disabled") {
    VStack(alignment: .leading, spacing: 24) {
        Text("TextArea - Disabled").font(.title2.bold())

        VStack(alignment: .leading, spacing: 16) {
            Text("Disabled").font(.caption).foregroundColor(.secondary)
            TextArea(.constant("入力テキストです。"), placeholder: "プレースホルダー", maxLength: 100, isDisabled: true).frame(width: 300)
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("Disabled + Focus").font(.caption).foregroundColor(.secondary)
            TextArea(.constant("入力テキストです。"), placeholder: "プレースホルダー", maxLength: 100, isFocused: true, isDisabled: true).frame(width: 300)
        }
    }
    .padding()
}
