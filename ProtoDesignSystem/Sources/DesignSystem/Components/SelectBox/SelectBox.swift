import SwiftUI

// https://stackoverflow.com/questions/65378209/make-picker-default-value-a-placeholder
public struct SelectBox: View {
    @State private var selectedOption = "選択してください"
    let options = ["オプション1", "オプション2", "オプション3", "オプション4"]

    public var body: some View {
        VStack {
            Picker("選択", selection: $selectedOption) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Color.gray, lineWidth: 1)
            )
        }
    }
}

#Preview {
    @Previewable @State var selectedOption: String = "Option A"

    SelectBox()

    VStack(spacing: 16) {
        Menu("Options") {
            Button("Option 1") {
                // Action for Option 1
            }
            Button("Option 2") {
                // Action for Option 2
            }
            Button("Option 3") {
                // Action for Option 3
            }
        }

        Picker("Select an Option", selection: $selectedOption) {
            Text("Option A").tag("Option A")
            Text("Option B").tag("Option B")
            Text("Option C").tag("Option C")
        }
        .pickerStyle(.menu)  // For a dropdown-like appearance
    }
}
