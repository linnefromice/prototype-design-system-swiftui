import SwiftUI

public struct CheckboxStyle: ToggleStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            Button {
                configuration.isOn.toggle()
            } label: {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(AppColor.Primitive.Blue.blue900)
            }
            .buttonStyle(.plain)
        }
    }
}

extension ToggleStyle where Self == CheckboxStyle {
    public static var customCheckbox: CheckboxStyle {
        CheckboxStyle()
    }
}

#Preview {
    VStack(spacing: 16) {
        HStack {
            Toggle("Checkbox", isOn: .constant(false))
                .toggleStyle(.customCheckbox)
            Text("False")
        }

        HStack {
            Toggle("Checkbox", isOn: .constant(true))
                .toggleStyle(.customCheckbox)
            Text("True")
        }
    }
}
