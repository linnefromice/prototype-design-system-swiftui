import SwiftUI

public enum ButtonTypeVariant: CaseIterable {
    case _default
    case hover
    case active
    case disabled
    
    var backgroundColor: SwiftUI.Color {
        switch self {
        case ._default: return AppColor.Primitive.Blue.blue900
        case .hover: return AppColor.Primitive.Blue.blue1000
        case .active: return AppColor.Primitive.Blue.blue1200
        case .disabled: return AppColor.Primitive.Blue.blue300
        }
    }
}
