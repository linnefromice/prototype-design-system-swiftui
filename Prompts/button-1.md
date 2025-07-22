@ProtoDesignSystem/Sources/DesignSystem/Button/DefaultButton.swift

下記の Figma にあるボタンのデザインを実装してください

https://www.figma.com/design/aZxq8BrVgvK3RmjqrpRoi9/%E3%83%87%E3%82%B8%E3%82%BF%E3%83%AB%E5%BA%81%E3%83%87%E3%82%B6%E3%82%A4%E3%83%B3%E3%82%B7%E3%82%B9%E3%83%86%E3%83%A0-%E3%83%87%E3%82%B6%E3%82%A4%E3%83%B3%E3%83%87%E3%83%BC%E3%82%BF-v2.5.1--Community-?node-id=8392-32301&m=dev

SwiftUI のスニペットでみると以下の通りです

HStack(alignment: .center, spacing: 4) { ... }
.padding(16)
.background(Constants.ColorPrimitiveBlue900)
.cornerRadius(Constants.BorderRadius8)

struct Constants {
  static let ColorPrimitiveBlue900: Color = Color(red: 0, green: 0.09, blue: 0.76)
  static let BorderRadius8: CGFloat = 8
}