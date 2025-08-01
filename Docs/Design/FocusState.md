# Design>FocusState

コンポーネントやフォームなどの複合UIにおけるフォーカス状態の扱いについて整理する

## 基本原則

- SwiftUIでは`@FocusState`でフォーカス状態を扱える
- Component 化において、単項目のフォームアイテムと複数アイテムによる複合フォームにおいて `@FocusState` の扱いが難しいため、方針を整理する

## 実装パターン

### 1. 単項目のフォームアイテムの場合

- 呼び出し側の View で `.focused` を付与するようにする
- Component 側では `@FocusState` 含めて管理しない
- **メリット**: コンポーネントがシンプルで再利用しやすい
- **例**:

```swift
struct ParentView: View {
    @FocusState private var isFieldFocused: Bool
    
    var body: some View {
        CustomTextField()
            .focused($isFieldFocused)
    }
}
```

### 2. 複数アイテムの複合フォームにおいて

- `FocusState<T>.Binding` により `FocusState` をパスすることでコンポーネント側で操作可能にする
- **メリット**: フォーカス状態に基づく視覚的フィードバックをコンポーネント内で管理できる
- **例**:

```swift
struct CustomButton: View {
    var focusState: FocusState<Bool>.Binding
    
    var body: some View {
        Button("Action") { }
            .focused(focusState)
            .overlay(
                // フォーカス時のボーダー表示
                focusState.wrappedValue ? border : nil
            )
    }
}
```

## ベストプラクティス

1. **視覚的フィードバックが必要な場合**
   - コンポーネント側で`FocusState.Binding`を受け取る
   - フォーカス状態に応じたスタイリングをコンポーネント内で実装

2. **複数の要素を管理する場合**
   - enumを使用して`FocusState<FocusableField?>`として管理
   - 拡張メソッドでBindingの変換を簡潔に

3. **デフォルト値の提供**
   - オプショナルなパラメータとして実装し、フォーカス管理が不要な場合にも対応

## 参考

- [SwiftUIの@FocusStateをViewと分離したい - inSmartBank](https://blog.smartbank.co.jp/entry/2024/08/22/swiftui-focus-state)