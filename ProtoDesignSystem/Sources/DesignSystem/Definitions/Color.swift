import SwiftUI

struct Color {
    
    struct Neutral {
        static let white = SwiftUI.Color(red: 1, green: 1, blue: 1)
        static let black = SwiftUI.Color(red: 0, green: 0, blue: 0)
        
        struct SolidGray {
            static let solidGray50 = SwiftUI.Color(red: 0.976, green: 0.976, blue: 0.976)
            static let solidGray100 = SwiftUI.Color(red: 0.945, green: 0.945, blue: 0.949)
            static let solidGray200 = SwiftUI.Color(red: 0.894, green: 0.898, blue: 0.902)
            static let solidGray300 = SwiftUI.Color(red: 0.816, green: 0.820, blue: 0.824)
            static let solidGray400 = SwiftUI.Color(red: 0.635, green: 0.639, blue: 0.651)
            static let solidGray420 = SwiftUI.Color(red: 0.576, green: 0.580, blue: 0.592)
            static let solidGray500 = SwiftUI.Color(red: 0.431, green: 0.439, blue: 0.451)
            static let solidGray536 = SwiftUI.Color(red: 0.341, green: 0.345, blue: 0.361)
            static let solidGray600 = SwiftUI.Color(red: 0.271, green: 0.275, blue: 0.286)
            static let solidGray700 = SwiftUI.Color(red: 0.192, green: 0.196, blue: 0.204)
            static let solidGray800 = SwiftUI.Color(red: 0.122, green: 0.125, blue: 0.133)
            static let solidGray900 = SwiftUI.Color(red: 0.071, green: 0.071, blue: 0.075)
        }
        
        struct OpacityGray {
            static let opacityGray50 = SwiftUI.Color(red: 0, green: 0, blue: 0, opacity: 0.02)
            static let opacityGray100 = SwiftUI.Color(red: 0, green: 0, blue: 0, opacity: 0.04)
            static let opacityGray200 = SwiftUI.Color(red: 0, green: 0, blue: 0, opacity: 0.08)
            static let opacityGray300 = SwiftUI.Color(red: 0, green: 0, blue: 0, opacity: 0.16)
            static let opacityGray400 = SwiftUI.Color(red: 0, green: 0, blue: 0, opacity: 0.36)
            static let opacityGray420 = SwiftUI.Color(red: 0, green: 0, blue: 0, opacity: 0.42)
            static let opacityGray500 = SwiftUI.Color(red: 0, green: 0, blue: 0, opacity: 0.56)
            static let opacityGray536 = SwiftUI.Color(red: 0, green: 0, blue: 0, opacity: 0.64)
            static let opacityGray600 = SwiftUI.Color(red: 0, green: 0, blue: 0, opacity: 0.72)
            static let opacityGray700 = SwiftUI.Color(red: 0, green: 0, blue: 0, opacity: 0.80)
            static let opacityGray800 = SwiftUI.Color(red: 0, green: 0, blue: 0, opacity: 0.88)
            static let opacityGray900 = SwiftUI.Color(red: 0, green: 0, blue: 0, opacity: 0.92)
        }
    }
    
    struct Primitive {
        struct Blue {
            static let blue50 = SwiftUI.Color(red: 0.910, green: 0.945, blue: 0.996)
            static let blue100 = SwiftUI.Color(red: 0.851, green: 0.902, blue: 1)
            static let blue200 = SwiftUI.Color(red: 0.773, green: 0.843, blue: 0.984)
            static let blue300 = SwiftUI.Color(red: 0.616, green: 0.718, blue: 0.976)
            static let blue400 = SwiftUI.Color(red: 0.439, green: 0.588, blue: 0.973)
            static let blue500 = SwiftUI.Color(red: 0.286, green: 0.475, blue: 0.961)
            static let blue600 = SwiftUI.Color(red: 0.204, green: 0.376, blue: 0.984)
            static let blue700 = SwiftUI.Color(red: 0.149, green: 0.290, blue: 0.957)
            static let blue800 = SwiftUI.Color(red: 0, green: 0.192, blue: 0.847)
            static let blue900 = SwiftUI.Color(red: 0, green: 0.090, blue: 0.757)
            static let blue1000 = SwiftUI.Color(red: 0, green: 0.067, blue: 0.561)
            static let blue1100 = SwiftUI.Color(red: 0, green: 0, blue: 0.443)
            static let blue1200 = SwiftUI.Color(red: 0, green: 0, blue: 0.376)
        }
        
        struct LightBlue {
            static let lightBlue50 = SwiftUI.Color(red: 0.941, green: 0.976, blue: 1)
            static let lightBlue100 = SwiftUI.Color(red: 0.863, green: 0.941, blue: 1)
            static let lightBlue200 = SwiftUI.Color(red: 0.753, green: 0.894, blue: 1)
            static let lightBlue300 = SwiftUI.Color(red: 0.592, green: 0.827, blue: 1)
            static let lightBlue400 = SwiftUI.Color(red: 0.341, green: 0.722, blue: 1)
            static let lightBlue500 = SwiftUI.Color(red: 0.224, green: 0.671, blue: 1)
            static let lightBlue600 = SwiftUI.Color(red: 0, green: 0.545, blue: 0.949)
            static let lightBlue700 = SwiftUI.Color(red: 0.031, green: 0.467, blue: 0.843)
            static let lightBlue800 = SwiftUI.Color(red: 0, green: 0.400, blue: 0.745)
            static let lightBlue900 = SwiftUI.Color(red: 0, green: 0.333, blue: 0.678)
            static let lightBlue1000 = SwiftUI.Color(red: 0, green: 0.259, blue: 0.549)
            static let lightBlue1100 = SwiftUI.Color(red: 0, green: 0.192, blue: 0.416)
            static let lightBlue1200 = SwiftUI.Color(red: 0, green: 0.137, blue: 0.294)
        }
        
        struct Cyan {
            static let cyan50 = SwiftUI.Color(red: 0.914, green: 0.969, blue: 0.976)
            static let cyan100 = SwiftUI.Color(red: 0.784, green: 0.973, blue: 1)
            static let cyan200 = SwiftUI.Color(red: 0.600, green: 0.949, blue: 1)
            static let cyan300 = SwiftUI.Color(red: 0.475, green: 0.886, blue: 0.949)
            static let cyan400 = SwiftUI.Color(red: 0.169, green: 0.784, blue: 0.894)
            static let cyan500 = SwiftUI.Color(red: 0.004, green: 0.718, blue: 0.839)
            static let cyan600 = SwiftUI.Color(red: 0, green: 0.639, blue: 0.749)
            static let cyan700 = SwiftUI.Color(red: 0, green: 0.553, blue: 0.651)
            static let cyan800 = SwiftUI.Color(red: 0, green: 0.510, blue: 0.600)
            static let cyan900 = SwiftUI.Color(red: 0, green: 0.435, blue: 0.514)
            static let cyan1000 = SwiftUI.Color(red: 0, green: 0.380, blue: 0.451)
            static let cyan1100 = SwiftUI.Color(red: 0, green: 0.275, blue: 0.325)
            static let cyan1200 = SwiftUI.Color(red: 0, green: 0.180, blue: 0.212)
        }
        
        struct Green {
            static let green50 = SwiftUI.Color(red: 0.925, green: 0.976, blue: 0.918)
            static let green100 = SwiftUI.Color(red: 0.859, green: 0.984, blue: 0.843)
            static let green200 = SwiftUI.Color(red: 0.729, green: 0.957, blue: 0.698)
            static let green300 = SwiftUI.Color(red: 0.573, green: 0.922, blue: 0.529)
            static let green400 = SwiftUI.Color(red: 0.427, green: 0.890, blue: 0.365)
            static let green500 = SwiftUI.Color(red: 0.235, green: 0.820, blue: 0.145)
            static let green600 = SwiftUI.Color(red: 0.227, green: 0.725, blue: 0.145)
            static let green700 = SwiftUI.Color(red: 0.196, green: 0.612, blue: 0.125)
            static let green800 = SwiftUI.Color(red: 0.169, green: 0.529, blue: 0.110)
            static let green900 = SwiftUI.Color(red: 0.110, green: 0.376, blue: 0.063)
            static let green1000 = SwiftUI.Color(red: 0.071, green: 0.251, blue: 0.039)
            static let green1100 = SwiftUI.Color(red: 0.039, green: 0.141, blue: 0.020)
            static let green1200 = SwiftUI.Color(red: 0.031, green: 0.110, blue: 0.016)
        }
        
        struct Lime {
            static let lime50 = SwiftUI.Color(red: 0.961, green: 0.973, blue: 0.890)
            static let lime100 = SwiftUI.Color(red: 0.945, green: 0.969, blue: 0.765)
            static let lime200 = SwiftUI.Color(red: 0.906, green: 0.957, blue: 0.573)
            static let lime300 = SwiftUI.Color(red: 0.859, green: 0.941, blue: 0.333)
            static let lime400 = SwiftUI.Color(red: 0.827, green: 0.933, blue: 0.165)
            static let lime500 = SwiftUI.Color(red: 0.765, green: 0.902, blue: 0)
            static let lime600 = SwiftUI.Color(red: 0.675, green: 0.796, blue: 0)
            static let lime700 = SwiftUI.Color(red: 0.557, green: 0.659, blue: 0)
            static let lime800 = SwiftUI.Color(red: 0.463, green: 0.549, blue: 0)
            static let lime900 = SwiftUI.Color(red: 0.361, green: 0.427, blue: 0)
            static let lime1000 = SwiftUI.Color(red: 0.267, green: 0.318, blue: 0)
            static let lime1100 = SwiftUI.Color(red: 0.192, green: 0.227, blue: 0)
            static let lime1200 = SwiftUI.Color(red: 0.145, green: 0.173, blue: 0)
        }
        
        struct Yellow {
            static let yellow50 = SwiftUI.Color(red: 0.996, green: 0.969, blue: 0.867)
            static let yellow100 = SwiftUI.Color(red: 1, green: 0.945, blue: 0.761)
            static let yellow200 = SwiftUI.Color(red: 1, green: 0.902, blue: 0.557)
            static let yellow300 = SwiftUI.Color(red: 1, green: 0.851, blue: 0.310)
            static let yellow400 = SwiftUI.Color(red: 1, green: 0.804, blue: 0.110)
            static let yellow500 = SwiftUI.Color(red: 0.961, green: 0.737, blue: 0)
            static let yellow600 = SwiftUI.Color(red: 0.847, green: 0.651, blue: 0)
            static let yellow700 = SwiftUI.Color(red: 0.702, green: 0.541, blue: 0)
            static let yellow800 = SwiftUI.Color(red: 0.584, green: 0.451, blue: 0)
            static let yellow900 = SwiftUI.Color(red: 0.455, green: 0.349, blue: 0)
            static let yellow1000 = SwiftUI.Color(red: 0.337, green: 0.259, blue: 0)
            static let yellow1100 = SwiftUI.Color(red: 0.243, green: 0.188, blue: 0)
            static let yellow1200 = SwiftUI.Color(red: 0.184, green: 0.141, blue: 0)
        }
        
        struct Orange {
            static let orange50 = SwiftUI.Color(red: 1, green: 0.957, blue: 0.906)
            static let orange100 = SwiftUI.Color(red: 1, green: 0.918, blue: 0.808)
            static let orange200 = SwiftUI.Color(red: 1, green: 0.859, blue: 0.659)
            static let orange300 = SwiftUI.Color(red: 1, green: 0.780, blue: 0.455)
            static let orange400 = SwiftUI.Color(red: 1, green: 0.706, blue: 0.275)
            static let orange500 = SwiftUI.Color(red: 1, green: 0.616, blue: 0.047)
            static let orange600 = SwiftUI.Color(red: 0.925, green: 0.537, blue: 0)
            static let orange700 = SwiftUI.Color(red: 0.780, green: 0.451, blue: 0)
            static let orange800 = SwiftUI.Color(red: 0.647, green: 0.380, blue: 0.008)
            static let orange900 = SwiftUI.Color(red: 0.506, green: 0.298, blue: 0.008)
            static let orange1000 = SwiftUI.Color(red: 0.376, green: 0.220, blue: 0.004)
            static let orange1100 = SwiftUI.Color(red: 0.271, green: 0.161, blue: 0.004)
            static let orange1200 = SwiftUI.Color(red: 0.204, green: 0.118, blue: 0)
        }
        
        struct Red {
            static let red50 = SwiftUI.Color(red: 1, green: 0.914, blue: 0.914)
            static let red100 = SwiftUI.Color(red: 1, green: 0.831, blue: 0.831)
            static let red200 = SwiftUI.Color(red: 1, green: 0.718, blue: 0.718)
            static let red300 = SwiftUI.Color(red: 1, green: 0.561, blue: 0.561)
            static let red400 = SwiftUI.Color(red: 1, green: 0.365, blue: 0.365)
            static let red500 = SwiftUI.Color(red: 0.980, green: 0.192, blue: 0.192)
            static let red600 = SwiftUI.Color(red: 0.890, green: 0.110, blue: 0.110)
            static let red700 = SwiftUI.Color(red: 0.788, green: 0.059, blue: 0.059)
            static let red800 = SwiftUI.Color(red: 0.686, green: 0.020, blue: 0.020)
            static let red900 = SwiftUI.Color(red: 0.545, green: 0.012, blue: 0.012)
            static let red1000 = SwiftUI.Color(red: 0.408, green: 0, blue: 0)
            static let red1100 = SwiftUI.Color(red: 0.286, green: 0, blue: 0)
            static let red1200 = SwiftUI.Color(red: 0.220, green: 0.004, blue: 0.004)
        }
        
        struct Magenta {
            static let magenta50 = SwiftUI.Color(red: 0.992, green: 0.918, blue: 0.976)
            static let magenta100 = SwiftUI.Color(red: 0.984, green: 0.839, blue: 0.957)
            static let magenta200 = SwiftUI.Color(red: 0.973, green: 0.722, blue: 0.929)
            static let magenta300 = SwiftUI.Color(red: 0.957, green: 0.561, blue: 0.890)
            static let magenta400 = SwiftUI.Color(red: 0.941, green: 0.369, blue: 0.843)
            static let magenta500 = SwiftUI.Color(red: 0.910, green: 0.192, blue: 0.788)
            static let magenta600 = SwiftUI.Color(red: 0.816, green: 0.094, blue: 0.686)
            static let magenta700 = SwiftUI.Color(red: 0.690, green: 0.031, blue: 0.569)
            static let magenta800 = SwiftUI.Color(red: 0.580, green: 0, blue: 0.471)
            static let magenta900 = SwiftUI.Color(red: 0.459, green: 0, blue: 0.369)
            static let magenta1000 = SwiftUI.Color(red: 0.345, green: 0, blue: 0.275)
            static let magenta1100 = SwiftUI.Color(red: 0.243, green: 0, blue: 0.192)
            static let magenta1200 = SwiftUI.Color(red: 0.188, green: 0, blue: 0.149)
        }
        
        struct Purple {
            static let purple50 = SwiftUI.Color(red: 0.957, green: 0.929, blue: 1)
            static let purple100 = SwiftUI.Color(red: 0.918, green: 0.867, blue: 1)
            static let purple200 = SwiftUI.Color(red: 0.867, green: 0.784, blue: 1)
            static let purple300 = SwiftUI.Color(red: 0.796, green: 0.667, blue: 1)
            static let purple400 = SwiftUI.Color(red: 0.714, green: 0.525, blue: 1)
            static let purple500 = SwiftUI.Color(red: 0.631, green: 0.384, blue: 1)
            static let purple600 = SwiftUI.Color(red: 0.557, green: 0.267, blue: 0.996)
            static let purple700 = SwiftUI.Color(red: 0.478, green: 0.141, blue: 0.957)
            static let purple800 = SwiftUI.Color(red: 0.412, green: 0.051, blue: 0.890)
            static let purple900 = SwiftUI.Color(red: 0.333, green: 0, blue: 0.776)
            static let purple1000 = SwiftUI.Color(red: 0.251, green: 0, blue: 0.588)
            static let purple1100 = SwiftUI.Color(red: 0.176, green: 0, blue: 0.412)
            static let purple1200 = SwiftUI.Color(red: 0.137, green: 0, blue: 0.318)
        }
    }
    
    struct Semantic {
        struct Error {
            static let error1 = SwiftUI.Color(red: 0.980, green: 0.192, blue: 0.192)
            static let error2 = SwiftUI.Color(red: 0.890, green: 0.110, blue: 0.110)
        }
        
        struct Success {
            static let success1 = SwiftUI.Color(red: 0.235, green: 0.820, blue: 0.145)
            static let success2 = SwiftUI.Color(red: 0.227, green: 0.725, blue: 0.145)
        }
        
        struct Warning {
            struct Orange {
                static let orange1 = SwiftUI.Color(red: 1, green: 0.616, blue: 0.047)
                static let orange2 = SwiftUI.Color(red: 0.925, green: 0.537, blue: 0)
            }
            
            struct Yellow {
                static let yellow1 = SwiftUI.Color(red: 0.961, green: 0.737, blue: 0)
                static let yellow2 = SwiftUI.Color(red: 0.847, green: 0.651, blue: 0)
            }
        }
    }
}