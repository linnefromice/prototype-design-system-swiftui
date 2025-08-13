import SwiftUI

public struct CheckboxStyle: ToggleStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            Button {
                configuration.isOn.toggle()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            configuration.isOn
                                ? AppColor.Primitive.Blue.blue600 : AppColor.Neutral.white
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(AppColor.Neutral.SolidGray.solidGray400, lineWidth: 1)
                        )

                    if configuration.isOn {
                        Image(systemName: "checkmark")
                            .resizable()
                            .frame(width: 8, height: 8)
                            .foregroundColor(AppColor.Neutral.white)
                    }
                }
                .frame(width: 20, height: 20)
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
    @Previewable @State var isOn: Bool = false

    VStack(spacing: 16) {
        HStack {
            Toggle("Checkbox", isOn: $isOn)
                .toggleStyle(.customCheckbox)
            Text("Checkbox")
        }

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
