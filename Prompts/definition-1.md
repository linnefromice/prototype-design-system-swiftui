@Resources/Color.json
@ProtoDesignSystem/Sources/DesignSystem/Definitions/Color.swift

Figma で定義された Color に関する Local Variable を Color.json に出力しました。
これをベースに Color.swift を実装してください。

struct Color { ... } で static なフィールドを実装してほしいです。
ex
Color/Neutral/White -> Color.Neutral.white
Color/Neutral/SolidGray/50 -> Color/Neutral/solidGray50
