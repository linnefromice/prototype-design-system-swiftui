import SwiftUI

public enum ButtonSizeVariant: CaseIterable {
    case large
    case medium
    case small
    case xSmall

    var xPadding: CGFloat {
        switch self {
        case .large, .medium: return 16
        case .small: return 12
        case .xSmall: return 8
        }
    }

    var yPadding: CGFloat {
        switch self {
        case .large: return 16
        case .medium: return 12
        case .small, .xSmall: return 8
        }
    }
}
