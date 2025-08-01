# Sizing

SwiftUIコンポーネントにおけるサイズ管理の実装方針

## 基本原則

### 1. Range指定版 frame の推奨

固定サイズではなく、範囲指定版の`frame(minWidth:idealWidth:maxWidth:...)`を使用することを推奨します。

#### なぜRange指定版が良いのか

**レスポンシブ設計への対応**

```swift
// ❌ 固定サイズ - 端末やコンテンツに適応できない
Text("User Name")
    .frame(width: 200, height: 44)

// ✅ 範囲指定 - 様々な状況に柔軟に対応
Text("User Name")
    .frame(minWidth: 100, maxWidth: 300, height: 44)
```

**多様な画面サイズへの対応**

```swift
// iPhone SE から iPad Pro まで対応
VStack {
    // コンテンツ
}
.frame(
    minWidth: 320,      // iPhone SEでも崩れない
    idealWidth: 400,    // 理想的なサイズ
    maxWidth: 600       // iPadで無駄に広がらない
)
```

**Dynamic Type（文字サイズ変更）への対応**

```swift
// 文字サイズが大きくなっても適切に拡張される
Button("ログイン") {
    // action
}
.frame(
    minWidth: 120,
    maxWidth: .infinity,
    minHeight: 44        // アクセシビリティ推奨の最小タップサイズ
)
```

### 2. コンポーネント種別によるサイズ管理方針

#### 単一要素コンポーネント

- 基本的に `.frame` によるサイズ指定は行わない
- `.padding` による空白指定も最小限に留める
- サイズは利用側で制御可能にする

```swift
// ✅ 良い例：単一要素はサイズ指定しない
struct IconButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
        }
    }
}

// 利用側でサイズを制御
IconButton(icon: "plus", action: {})
    .frame(width: 44, height: 44)
```

#### 複合要素コンポーネント

- `.frame` やSpacingのパラメータを適切に抽出
- 必要に応じて変更可能にする

```swift
// ✅ 良い例：複合要素はパラメータ化
struct LabeledButton: View {
    let title: String
    let subtitle: String
    let action: () -> Void
    
    // サイズ制御可能
    var spacing: CGFloat = 4
    var minWidth: CGFloat? = nil
    var maxWidth: CGFloat? = nil
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: spacing) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.caption)
            }
            .frame(minWidth: minWidth, maxWidth: maxWidth)
        }
    }
}
```

## 使い分けガイドライン

### 固定サイズを使うべき場合（稀）

```swift
// アイコンやプロフィール画像など、厳密なサイズが必要
Image("avatar")
    .frame(width: 40, height: 40)
    
// 装飾的な要素
Rectangle()
    .frame(width: 2, height: 50)  // 区切り線
```

### Range指定を使うべき場合（ほぼ全て）

```swift
// ✅ 一般的なUI要素
TextField("メールアドレス", text: $email)
    .frame(minWidth: 200, maxWidth: 400, height: 44)

// ✅ カード型レイアウト
VStack {
    // コンテンツ
}
.frame(minWidth: 280, idealWidth: 320, maxWidth: 500)

// ✅ ボタン
Button("送信") { }
    .frame(minWidth: 80, maxWidth: .infinity, minHeight: 44)
```

## 実践的な推奨パターン

### 横幅は可変、高さは固定
```swift
.frame(maxWidth: .infinity, height: 44)
```

### 最小サイズを保証しつつ可変
```swift
.frame(minWidth: 100, maxWidth: .infinity, minHeight: 44)
```

### 上限を設けた中央寄せレイアウト
```swift
.frame(maxWidth: 600)  // 大画面で読みやすい幅に制限
```

## デザインシステムでの実装例

### ButtonWidthVariant
```swift
enum ButtonWidthVariant {
    case flexible                              // コンテンツに応じて可変
    case fixed(CGFloat)                        // 固定幅
    case fill                                  // 親の幅いっぱい
    case range(min: CGFloat?, max: CGFloat?)  // 最小/最大幅を指定
}
```

### 推奨サイズ定数
```swift
struct SizingConstants {
    // 最小タップ領域
    static let minTapTarget: CGFloat = 44
    
    // ボタンの推奨幅
    static let buttonMinWidth: CGFloat = 80
    static let buttonStandardMaxWidth: CGFloat = 200
    static let buttonExpandedMaxWidth: CGFloat = 300
    
    // 読みやすいコンテンツ幅
    static let readableContentMaxWidth: CGFloat = 600
}
```

## まとめ

1. **固定サイズよりRange指定を優先** - レスポンシブ性とアクセシビリティの向上
2. **単一要素は制約を最小限に** - 再利用性の確保
3. **複合要素はパラメータ化** - 柔軟性と一貫性のバランス
4. **アクセシビリティを考慮** - 最小タップ領域44ptの確保

これらの方針により、様々なデバイスと使用状況に対応できる、柔軟で保守性の高いコンポーネントを実現できます。