import SwiftUI

struct Typography {
    
    struct FontSize {
        static let size14: CGFloat = 14
        static let size16: CGFloat = 16
        static let size17: CGFloat = 17
        static let size18: CGFloat = 18
        static let size20: CGFloat = 20
        static let size22: CGFloat = 22
        static let size24: CGFloat = 24
        static let size26: CGFloat = 26
        static let size28: CGFloat = 28
        static let size32: CGFloat = 32
        static let size36: CGFloat = 36
        static let size45: CGFloat = 45
        static let size48: CGFloat = 48
        static let size57: CGFloat = 57
        static let size64: CGFloat = 64
    }
    
    struct FontWeight {
        static let regular: SwiftUI.Font.Weight = .regular
        static let bold: SwiftUI.Font.Weight = .bold
    }
    
    struct FontFamily {
        static let sans: String = "Noto Sans JP"
        static let mono: String = "Noto Sans Mono"
    }
    
}