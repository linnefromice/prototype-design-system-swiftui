# Prefire設定ガイド

## 📌 概要

このプロジェクトでは[Prefire](https://github.com/BarredEwe/Prefire)を使用してSwiftUIプレビューからスナップショットテストを自動生成しています。

**設定ファイル**: `.prefire.yml`（プロジェクトルート）

## 🔧 設定内容

### test_configuration

```yaml
test_configuration:
  target: ProtoDesignSystemTests
  test_target_path: ${PROJECT_DIR}/ProtoDesignSystemTests
  test_file_path: ProtoDesignSystemTests/PreviewTests.generated.swift
  simulator_device: "iPhone15,2"
  required_os: 16
  preview_default_enabled: true
  use_grouped_snapshots: true
  sources:
    - ${PROJECT_DIR}/ProtoDesignSystem/Sources/
  snapshot_devices:
    - iPhone 14
    - iPad
  imports:
    - SwiftUI
  testable_imports:
    - ProtoDesignSystem
```

### パラメータ説明

| パラメータ | 値 | 説明 |
|-----------|-----|------|
| `target` | `ProtoDesignSystemTests` | スナップショット生成に使用するテストターゲット名 |
| `test_target_path` | `${PROJECT_DIR}/ProtoDesignSystemTests` | テストターゲットのディレクトリパス |
| `test_file_path` | `ProtoDesignSystemTests/PreviewTests.generated.swift` | 生成されるテストファイルのパス |
| `simulator_device` | `"iPhone15,2"` | テスト実行に使用するシミュレータデバイス識別子 |
| `required_os` | `16` | プレビュー描画に必要な最小iOSバージョン |
| `preview_default_enabled` | `true` | 全てのプレビューをデフォルトで有効化 |
| `use_grouped_snapshots` | `true` | 全プレビューを1つのテストファイルにまとめる |
| `sources` | `${PROJECT_DIR}/ProtoDesignSystem/Sources/` | プレビューを検索するソースディレクトリ |
| `snapshot_devices` | `["iPhone 14", "iPad"]` | スナップショット生成対象のデバイス |
| `imports` | `["SwiftUI"]` | 生成されるテストファイルにインポートするモジュール |
| `testable_imports` | `["ProtoDesignSystem"]` | `@testable import` するモジュール |

## 📂 スナップショット出力先

Prefireの制約により、スナップショットは以下のパスに出力されます:

```
{test_target_path}/__Snapshots__/{test_file_name}/
```

このプロジェクトの場合:

```
ProtoDesignSystemTests/__Snapshots__/PreviewTests.generated/
```

**重要**: Prefireの設定では、スナップショット出力先を`docs/`配下などに直接指定することはできません。

## 🔄 ワークフロー

### 1. プレビューの作成

コンポーネントファイルに`#Preview`を追加:

```swift
// ProtoDesignSystem/Sources/DesignSystem/Components/Button/SolidFillButton.swift

#Preview {
    SolidFillButton(
        label: "ボタン",
        action: {},
        typeVariant: .default,
        sizeVariant: .medium
    )
}
```

### 2. スナップショットテストの生成

Prefireがプレビューを検出し、`PreviewTests.generated.swift`を自動生成します。

### 3. テストの実行

Xcodeでスナップショットテストを実行:

```bash
# XcodeでProtoDesignSystemTestsスキームを選択してテスト実行
# または
xcodebuild test \
  -project ProtoDesignSystem.xcodeproj \
  -scheme ProtoDesignSystemTests \
  -destination 'platform=iOS Simulator,name=iPhone 14'
```

### 4. スナップショットの確認

生成されたPNG:

```
ProtoDesignSystemTests/__Snapshots__/PreviewTests.generated/
├── Button_0.1.png
├── Checkbox_0.1.png
├── InputText_0.1.png
└── ...
```

### 5. Hugoカタログへの反映

```bash
# スナップショットをHugoカタログ用にコピー・データ生成
python Scripts/prepare_snapshot_catalog.py --clean

# Hugoで確認
cd docs && hugo server
```

## 📱 対応デバイス

### snapshot_devices

現在の設定では以下のデバイスでスナップショットを生成:

- **iPhone 14**: iPhoneサイズでのプレビュー
- **iPad**: iPadサイズでのプレビュー

### デバイスの追加

デバイスを追加する場合は`.prefire.yml`を編集:

```yaml
snapshot_devices:
  - iPhone 14
  - iPhone 14 Pro Max
  - iPad
  - iPad Pro (12.9-inch)
```

**注意**: デバイス数が増えるとスナップショット生成時間が増加します。

## 🎯 プレビューの制御

### 特定のプレビューのみ有効化

`preview_default_enabled: false`に設定し、個別にマーク:

```swift
#Preview {
    Button(label: "テスト")
}
.prefireEnabled()  // このプレビューのみスナップショット生成
```

### プレビューの無効化

特定のプレビューをスナップショット生成から除外:

```swift
#Preview {
    Button(label: "開発用プレビュー")
}
.prefireDisabled()  // スナップショット生成をスキップ
```

## 🔍 トラブルシューティング

### スナップショットが生成されない

**確認事項**:
1. `.prefire.yml`の`sources`パスが正しいか
2. プレビューファイルに`#Preview`マクロが使用されているか
3. `preview_default_enabled: true`になっているか
4. Xcodeでテストが実行されているか

### スナップショット出力先を変更したい

Prefireの制約により、出力先は`{test_target_path}/__Snapshots__/`に固定されます。

**代替案**:
1. スナップショット生成後に`prepare_snapshot_catalog.py`でコピー（推奨）
2. シンボリックリンクを使用（非推奨、CI環境での互換性に注意）

### デバイス識別子の確認

```bash
# 利用可能なシミュレータデバイスの一覧
xcrun simctl list devices

# 例:
# iPhone 15 (XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX) (Shutdown)
# → simulator_device: "iPhone15,2"
```

## 📊 ファイル命名規則

Prefireが生成するスナップショットファイル名:

```
{PreviewName}_{index}.{scale}.png
```

**例**:
- `Button_0.1.png` - 最初のButtonプレビュー、1x解像度
- `Button_0.2.png` - 最初のButtonプレビュー、2x解像度
- `Checkbox_1.1.png` - 2番目のCheckboxプレビュー、1x解像度

### メタデータ抽出の活用

詳細なメタデータを抽出するには、プレビュー名を構造化:

```swift
#Preview("Button_small_hover") {  // コンポーネント_バリアント_状態
    Button(label: "ボタン", size: .small, state: .hover)
}
```

→ `Scripts/prepare_snapshot_catalog.py`が自動的に以下を抽出:
- component: "Button"
- variant: "small"
- state: "hover"

詳細は`Scripts/README.md`を参照。

## 🔗 関連ドキュメント

- [Prefire GitHub](https://github.com/BarredEwe/Prefire)
- [スナップショットメタデータ抽出](Snapshot-Metadata-Extraction-Implementation.md)
- [スクリプト使用方法](../Scripts/README.md)
- [実装計画](Implementation-Plan-Snapshot-Catalog-Improvements.md)

## 📝 設定変更履歴

| 日付 | 変更内容 |
|------|---------|
| 2025-12-05 | 初期設定ファイル作成（Phase 1実装） |

## 🚀 次のステップ

1. Xcodeでスナップショットテストを実行
2. 生成されたPNGを確認
3. `prepare_snapshot_catalog.py`でHugoカタログを更新
4. GitHub Pagesで公開されたカタログを確認
