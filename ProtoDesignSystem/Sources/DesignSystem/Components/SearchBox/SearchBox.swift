import SwiftUI

// MARK: - SearchBox

public struct SearchBox: View {
    @Binding var query: String
    let scopeLabel: String
    let scopeValue: String
    let placeholder: String
    let isDisabled: Bool
    let error: String?
    let onSearch: () -> Void

    @FocusState private var isFocused: Bool

    public init(
        query: Binding<String>,
        scopeLabel: String = "検索対象",
        scopeValue: String = "すべて",
        placeholder: String = "キーワードを入力",
        isDisabled: Bool = false,
        error: String? = nil,
        onSearch: @escaping () -> Void
    ) {
        self._query = query
        self.scopeLabel = scopeLabel
        self.scopeValue = scopeValue
        self.placeholder = placeholder
        self.isDisabled = isDisabled
        self.error = error
        self.onSearch = onSearch
    }

    var hasError: Bool {
        error != nil
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                // Left: Scope Selector + TextField Container
                HStack(spacing: 0) {
                    SearchScopeSelector(
                        label: scopeLabel,
                        value: scopeValue,
                        isDisabled: isDisabled
                    )

                    Divider()
                        .frame(width: 1, height: 44)
                        .background(AppColor.Neutral.SolidGray.solidGray300)

                    SearchTextField(
                        query: $query,
                        placeholder: placeholder,
                        isFocused: isFocused,
                        isDisabled: isDisabled
                    )
                    .focused($isFocused)
                }
                .background(
                    isDisabled
                        ? AppColor.Neutral.SolidGray.solidGray50
                        : AppColor.Neutral.white
                )
                .overlay(
                    ZStack {
                        baseBorder
                        if isFocused && !isDisabled {
                            focusRing
                        }
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))

                // Right: Search Button
                Button(action: onSearch) {
                    Text("検索")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(AppColor.Neutral.white)
                        .frame(minWidth: 80)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(
                            isDisabled
                                ? AppColor.Neutral.SolidGray.solidGray300
                                : AppColor.Primitive.Blue.blue700
                        )
                        .cornerRadius(8)
                }
                .buttonStyle(.plain)
                .disabled(isDisabled)
            }

            // Error message
            if let errorMessage = error {
                Text("* \(errorMessage)")
                    .font(.system(size: 16))
                    .foregroundColor(AppColor.Semantic.Error.error1)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("検索ボックス")
    }

    // MARK: - Border Styles

    private var baseBorder: some View {
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

    private var focusRing: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(AppColor.Primitive.Yellow.yellow300, lineWidth: 2)
                .padding(-1)

            RoundedRectangle(cornerRadius: 8)
                .stroke(AppColor.Neutral.black, lineWidth: 2)
                .padding(-2)
        }
    }
}

// MARK: - SearchScopeSelector

struct SearchScopeSelector: View {
    let label: String
    let value: String
    let isDisabled: Bool

    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption2)
                    .foregroundColor(
                        isDisabled
                            ? AppColor.Neutral.SolidGray.solidGray420
                            : AppColor.Neutral.SolidGray.solidGray600
                    )
                Text(value)
                    .font(.body)
                    .foregroundColor(
                        isDisabled
                            ? AppColor.Neutral.SolidGray.solidGray420
                            : AppColor.Neutral.SolidGray.solidGray900
                    )
            }

            Image(systemName: "chevron.down")
                .foregroundColor(
                    isDisabled
                        ? AppColor.Neutral.SolidGray.solidGray420
                        : AppColor.Neutral.SolidGray.solidGray600
                )
                .font(.caption)
        }
        .padding(.horizontal, 12)
        .frame(height: 44)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(value)")
        .accessibilityHint("検索対象を選択")
    }
}

// MARK: - SearchTextField

struct SearchTextField: View {
    @Binding var query: String
    let placeholder: String
    let isFocused: Bool
    let isDisabled: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    isDisabled
                        ? AppColor.Neutral.SolidGray.solidGray420
                        : AppColor.Neutral.SolidGray.solidGray600
                )
                .font(.system(size: 16))

            ZStack(alignment: .leading) {
                if query.isEmpty {
                    Text(placeholder)
                        .foregroundColor(AppColor.Neutral.SolidGray.solidGray420)
                }
                TextField("", text: $query)
                    .foregroundColor(
                        isDisabled
                            ? AppColor.Neutral.SolidGray.solidGray420
                            : AppColor.Neutral.SolidGray.solidGray900
                    )
                    .disabled(isDisabled)
            }
        }
        .padding(.horizontal, 12)
        .frame(height: 44)
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(alignment: .leading, spacing: 40) {
            Text("SearchBox States")
                .font(.title.bold())

            VStack(spacing: 24) {
                // Default
                HStack(spacing: 20) {
                    Text("Default")
                        .frame(width: 120, alignment: .trailing)
                        .font(.caption)

                    SearchBox(
                        query: .constant(""),
                        scopeLabel: "検索対象",
                        scopeValue: "すべて",
                        placeholder: "キーワードを入力",
                        onSearch: {}
                    )
                }

                // With Query
                HStack(spacing: 20) {
                    Text("With Query")
                        .frame(width: 120, alignment: .trailing)
                        .font(.caption)

                    SearchBox(
                        query: .constant("SwiftUI"),
                        scopeLabel: "検索対象",
                        scopeValue: "すべて",
                        onSearch: {}
                    )
                }

                // Different Scope
                HStack(spacing: 20) {
                    Text("Different Scope")
                        .frame(width: 120, alignment: .trailing)
                        .font(.caption)

                    SearchBox(
                        query: .constant(""),
                        scopeLabel: "検索対象",
                        scopeValue: "人物",
                        placeholder: "人物名を入力",
                        onSearch: {}
                    )
                }

                // Error
                HStack(spacing: 20) {
                    Text("Error")
                        .frame(width: 120, alignment: .trailing)
                        .font(.caption)

                    SearchBox(
                        query: .constant(""),
                        scopeLabel: "検索対象",
                        scopeValue: "すべて",
                        error: "検索キーワードを入力してください。",
                        onSearch: {}
                    )
                }

                // Disabled
                HStack(spacing: 20) {
                    Text("Disabled")
                        .frame(width: 120, alignment: .trailing)
                        .font(.caption)

                    SearchBox(
                        query: .constant(""),
                        scopeLabel: "検索対象",
                        scopeValue: "すべて",
                        isDisabled: true,
                        onSearch: {}
                    )
                }

                // Disabled with Query
                HStack(spacing: 20) {
                    Text("Disabled with Query")
                        .frame(width: 120, alignment: .trailing)
                        .font(.caption)

                    SearchBox(
                        query: .constant("SwiftUI"),
                        scopeLabel: "検索対象",
                        scopeValue: "すべて",
                        isDisabled: true,
                        onSearch: {}
                    )
                }
            }

            Divider()
                .padding(.vertical)

            Text("Different Scopes")
                .font(.title.bold())

            VStack(spacing: 16) {
                SearchBox(
                    query: .constant(""),
                    scopeLabel: "検索対象",
                    scopeValue: "すべて",
                    onSearch: {}
                )

                SearchBox(
                    query: .constant(""),
                    scopeLabel: "検索対象",
                    scopeValue: "人物",
                    placeholder: "人物名を入力",
                    onSearch: {}
                )

                SearchBox(
                    query: .constant(""),
                    scopeLabel: "検索対象",
                    scopeValue: "法令",
                    placeholder: "法令名を入力",
                    onSearch: {}
                )

                SearchBox(
                    query: .constant(""),
                    scopeLabel: "検索対象",
                    scopeValue: "コンポーネント",
                    placeholder: "コンポーネント名を入力",
                    onSearch: {}
                )
            }

            Divider()
                .padding(.vertical)

            Text("Interactive Example")
                .font(.title.bold())

            InteractiveSearchBoxPreview()
        }
        .padding()
    }
    .preferredColorScheme(.light)
}

// MARK: - Interactive Preview Helper

struct InteractiveSearchBoxPreview: View {
    @State private var query = ""
    @State private var searchResults: [String] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SearchBox(
                query: $query,
                scopeLabel: "検索対象",
                scopeValue: "すべて",
                placeholder: "キーワードを入力",
                onSearch: performSearch
            )

            if !searchResults.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("検索結果:")
                        .font(.headline)

                    ForEach(searchResults, id: \.self) { result in
                        Text("• \(result)")
                            .font(.body)
                    }
                }
                .padding()
                .background(AppColor.Neutral.SolidGray.solidGray50)
                .cornerRadius(8)
            }
        }
    }

    private func performSearch() {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        searchResults = [
            "検索結果: \"\(query)\" に一致する項目",
            "項目 1: \(query) の説明",
            "項目 2: \(query) の詳細",
            "項目 3: \(query) の関連情報"
        ]
    }
}
