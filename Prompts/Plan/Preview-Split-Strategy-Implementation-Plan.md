# Previewスナップショット分割戦略 - 実装計画

## 📌 問題の概要

**現状**: SwiftUIの`#Preview`が1つの大きなスクロールビューで全バリエーションを表示しているため、スナップショット画像が1画面に収まらず、多くのバリエーションが見切れている。

**影響**:
- UIカタログで一部のバリエーションが確認できない
- スナップショット画像が大きすぎる（144KB～310KB）
- プレビューの視認性が低い

**目標**: 各バリエーションを個別のプレビューに分割し、全てのUIパターンが見えるスナップショットを生成する。

---

## 🔍 現状分析

### 現在のPreviewパターン

コンポーネントは主に以下のパターンでPreviewを定義している:

#### パターンA: 全バリエーションを1つのScrollViewで表示

```swift
#Preview {
    ScrollView {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
            ForEach(ButtonTypeVariant.allCases) { typeVariant in
                ForEach(ButtonSizeVariant.allCases) { sizeVariant in
                    // 複数の状態を表示
                    SolidFillButton(..., typeVariant: typeVariant, sizeVariant: sizeVariant)
                }
            }
        }
    }
}
```

**問題点**:
- 4つのtypeVariant × 3つのsizeVariant × 2つの状態（focused/unfocused）= 24パターンが1つの画像に
- ScrollViewの高さが画面を超え、下部のバリエーションが見切れる

#### パターンB: VStackで縦に並べる

```swift
#Preview {
    VStack(spacing: 32) {
        ForEach(CheckboxSizeVariant.allCases) { size in
            // 各サイズのバリエーション
        }
    }
}
```

**同様の問題**: 多くのバリエーションで画面外に

### スナップショットファイル名の現状

```
Banner_0.1.png          # 全バリエーションが1ファイル
Checkbox_0.1.png        # 全バリエーションが1ファイル
SolidFillButton_0.1.png # 全バリエーションが1ファイル
```

---

## 🎯 解決戦略

### [1] Previewの分割方針

#### 分割軸の定義

コンポーネントのバリエーションを以下の軸で分割:

1. **Size（サイズ）**: small, medium, large
2. **Type/State（状態）**: default, hover, active, disabled, error
3. **Focus（フォーカス）**: focused, unfocused
4. **Layout（レイアウト）**: horizontal, vertical（該当コンポーネントのみ）

#### 分割ルール

**原則**: 1つのプレビューは画面内（約800px高さ）に収まるバリエーション数にする

**具体的な分割方法**:

```swift
// ❌ 悪い例: 全バリエーションを1つのPreviewに
#Preview {
    ScrollView {
        // 24パターン全てを表示 → 見切れる
    }
}

// ✅ 良い例: サイズごとに分割
#Preview("Button - Small") {
    VStack {
        // Small サイズの全状態（4 type × 2 focus = 8パターン）
        ForEach(ButtonTypeVariant.allCases) { type in
            SolidFillButton(..., sizeVariant: .small, typeVariant: type)
            SolidFillButton(..., sizeVariant: .small, typeVariant: type, isFocused: true)
        }
    }
}

#Preview("Button - Medium") {
    VStack {
        // Medium サイズの全状態
    }
}

#Preview("Button - Large") {
    VStack {
        // Large サイズの全状態
    }
}
```

### [2] コンポーネント別分割戦略

#### Button系コンポーネント

**現状**: SolidFillButton, OutlineButton, TextButton

**バリエーション**:
- Type: 4種類（default, hover, active, disabled）
- Size: 3種類（small, medium, large）
- Focus: 2種類（focused, unfocused）
- 合計: 4 × 3 × 2 = 24パターン

**分割案**:
```swift
#Preview("SolidFillButton - Small")      // 8パターン
#Preview("SolidFillButton - Medium")     // 8パターン
#Preview("SolidFillButton - Large")      // 8パターン
```

**生成されるファイル名**:
```
SolidFillButton_Small_0.1.png
SolidFillButton_Medium_0.1.png
SolidFillButton_Large_0.1.png
```

#### Checkbox

**現状**: 全サイズ × 全状態を1つのPreviewに

**バリエーション**:
- Size: 3種類（sm, md, lg）
- State: 4種類（unchecked, checked, indeterminate, disabled）
- 合計: 3 × 4 = 12パターン

**分割案**:
```swift
#Preview("Checkbox - Small")   // 4パターン
#Preview("Checkbox - Medium")  // 4パターン
#Preview("Checkbox - Large")   // 4パターン
```

#### RadioButton

**現状**: 16状態を1つのPreviewに表示

**バリエーション**:
- State: 16種類（各種組み合わせ）

**分割案**:
```swift
#Preview("RadioButton - Basic States")    // 基本4状態
#Preview("RadioButton - Focus States")    // フォーカス関連4状態
#Preview("RadioButton - Disabled States") // 無効状態4状態
#Preview("RadioButton - Error States")    // エラー状態4状態
```

#### ChipLabel / ChipTag

**現状**: 全スタイル × 全カラーを1つのPreviewに

**分割案**:
```swift
#Preview("ChipLabel - Default Style")  // 全カラー
#Preview("ChipLabel - Outline Style")  // 全カラー
#Preview("ChipLabel - Filled Style")   // 全カラー
#Preview("ChipLabel - Tonal Style")    // 全カラー
```

#### Banner

**現状**: 5つのステータス × 2つのバリアント × 2つのレイアウト = 20パターン

**分割案**:
```swift
#Preview("Banner - Info & Success")    // 2ステータス × 2バリアント
#Preview("Banner - Warning & Error")   // 2ステータス × 2バリアント
#Preview("Banner - Emergency")         // 1ステータス × 2バリアント
```

---

### [3] Hugoサイトへの反映方法

#### メタデータ抽出の拡張

現在の`prepare_snapshot_catalog.py`は以下のパターンを抽出:

```
ComponentName_variant_state_0.1.png
```

**拡張後のパターン**:

```
ComponentName_Size_0.1.png              # サイズ別
ComponentName_State_0.1.png             # 状態別
ComponentName_Size_State_0.1.png        # サイズ×状態
```

**例**:
```
SolidFillButton_Small_0.1.png
SolidFillButton_Medium_0.1.png
SolidFillButton_Large_0.1.png
Checkbox_Small_0.1.png
RadioButton_BasicStates_0.1.png
ChipLabel_DefaultStyle_0.1.png
```

#### JSON出力構造の拡張

```json
{
  "snapshots": [
    {
      "file": "SolidFillButton_Small_0.1.png",
      "component": "SolidFillButton",
      "category": "Form",
      "variant": "Small",
      "group": "Button",  // 新規: 同一コンポーネントのグループ化
      "title": "SolidFillButton Small"
    }
  ],
  "by_component": {
    "SolidFillButton": [
      { "file": "SolidFillButton_Small_0.1.png", ... },
      { "file": "SolidFillButton_Medium_0.1.png", ... },
      { "file": "SolidFillButton_Large_0.1.png", ... }
    ]
  }
}
```

#### Hugoレイアウトの改善

**現在**: 全スナップショットをフラットに表示

**改善後**: コンポーネントごとにグループ化して表示

```html
{{ range $component, $snapshots := .Site.Data.snapshots.by_component }}
<section class="component-group">
  <h2>{{ $component }}</h2>
  <div class="snapshot-grid">
    {{ range $snapshots }}
    <div class="snapshot-card">
      <img src="/snapshots/{{ .file }}" alt="{{ .title }}">
      <p>{{ .variant }}</p>
    </div>
    {{ end }}
  </div>
</section>
{{ end }}
```

---

## 📋 実装ステップ

### Phase 1: Previewの分割リファクタリング

**目標**: コンポーネントのPreviewを分割し、見切れのないスナップショットを生成

#### Step 1.1: Button系コンポーネント

- [ ] `SolidFillButton.swift`: 3つのPreviewに分割（Small, Medium, Large）
- [ ] `OutlineButton.swift`: 3つのPreviewに分割
- [ ] `TextButton.swift`: 3つのPreviewに分割

**期待されるファイル**:
```
SolidFillButton_Small_0.1.png
SolidFillButton_Medium_0.1.png
SolidFillButton_Large_0.1.png
OutlineButton_Small_0.1.png
OutlineButton_Medium_0.1.png
OutlineButton_Large_0.1.png
TextButton_Small_0.1.png
TextButton_Medium_0.1.png
TextButton_Large_0.1.png
```

#### Step 1.2: Form系コンポーネント

- [ ] `Checkbox.swift`: 3つのPreviewに分割（Small, Medium, Large）
- [ ] `RadioButton.swift`: 4つのPreviewに分割（Basic, Focus, Disabled, Error）
- [ ] `InputText.swift`: 状態別に分割
- [ ] `TextArea.swift`: 状態別に分割
- [ ] `SelectBox.swift`: 状態別に分割

#### Step 1.3: Content/Feedback系コンポーネント

- [ ] `ChipLabel.swift`: スタイル別に分割（4つのPreview）
- [ ] `ChipTag.swift`: スタイル別に分割
- [ ] `Banner.swift`: ステータスグループ別に分割（3つのPreview）
- [ ] `ProgressIndicator.swift`: タイプ別に分割

### Phase 2: スクリプトの拡張

#### Step 2.1: メタデータ抽出の改善

**ファイル**: `Scripts/prepare_snapshot_catalog.py`

```python
def extract_metadata(filename: str) -> SnapshotMetadata:
    # 新しいパターンに対応
    # ComponentName_Variant_0.1.png
    # ComponentName_StateGroup_0.1.png

    # グループ化情報を追加
    group = determine_group(component)  # Button系、Form系など
```

**追加機能**:
- `group`フィールドの追加
- `by_component`グループの生成
- Preview名（"Small", "Medium"等）の認識

#### Step 2.2: JSON出力構造の拡張

```python
def write_data_file(dest: Path, images: Iterable[Path], dry_run: bool = False) -> None:
    # 既存のby_categoryに加えて、by_componentを生成
    by_component = {}
    for entry in entries:
        comp = entry["component"]
        if comp not in by_component:
            by_component[comp] = []
        by_component[comp].append(entry)

    payload = {
        # ...
        "by_component": by_component,  # 新規追加
    }
```

### Phase 3: Hugoサイトの改善

#### Step 3.1: レイアウトの拡張

**ファイル**: `docs/layouts/index.html`

```html
<!-- コンポーネント別タブ表示 -->
<div class="tabs">
  <button onclick="showAll()">All</button>
  {{ range $component := .Site.Data.snapshots.by_component }}
  <button onclick="showComponent('{{ $component }}')">{{ $component }}</button>
  {{ end }}
</div>

<!-- コンポーネントグループ表示 -->
<div id="snapshot-container">
  {{ range $component, $snapshots := .Site.Data.snapshots.by_component }}
  <section class="component-section" data-component="{{ $component }}">
    <h2>{{ $component }}</h2>
    <div class="grid">
      {{ range $snapshots }}
      <div class="card">
        <img src="/snapshots/{{ .file }}" alt="{{ .title }}">
        <h3>{{ .variant }}</h3>
      </div>
      {{ end }}
    </div>
  </section>
  {{ end }}
</div>
```

#### Step 3.2: CSSの追加

```css
.component-section {
  margin-bottom: 3rem;
  padding: 2rem;
  background: #f9f9f9;
  border-radius: 8px;
}

.grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 1.5rem;
}

.card {
  background: white;
  border-radius: 8px;
  padding: 1rem;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.card img {
  width: 100%;
  height: auto;
  border-radius: 4px;
}
```

---

## 📊 期待される効果

### Before（現状）

```
全コンポーネント: 15ファイル
平均ファイルサイズ: 200KB
見切れているバリエーション: 60%以上
```

### After（改善後）

```
全コンポーネント: 約45-50ファイル（3倍）
平均ファイルサイズ: 50-80KB（60%削減）
見切れているバリエーション: 0%
視認性: 大幅向上
```

### メリット

1. **視認性の向上**: 全てのバリエーションが画面内に収まる
2. **ファイルサイズの削減**: 個別ファイルは小さくなり、読み込み高速化
3. **検索性の向上**: バリエーション名でフィルタリング可能
4. **メンテナンス性**: どのバリエーションが実装されているか一目瞭然

---

## 🚀 実装優先順位

| Phase | 優先度 | 所要時間（目安） | 依存関係 |
|-------|--------|------------------|----------|
| Phase 1.1 | 高 | 2-3時間 | なし |
| Phase 1.2 | 高 | 3-4時間 | なし |
| Phase 1.3 | 中 | 2-3時間 | なし |
| Phase 2 | 高 | 2-3時間 | Phase 1 |
| Phase 3 | 中 | 2-3時間 | Phase 2 |

**推奨実装順序**: Phase 1.1 → Phase 2 → Phase 3 → Phase 1.2 → Phase 1.3

---

## 🔍 技術的考慮事項

### Previewの命名規則

Prefireが生成するファイル名は、Previewの名前引数から決まる:

```swift
#Preview("ComponentName - VariantName") {
    // ...
}
```

→ 生成されるファイル名: `ComponentName-VariantName_0.1.png`

**推奨命名規則**:

```swift
// サイズ別
#Preview("SolidFillButton - Small")
#Preview("SolidFillButton - Medium")
#Preview("SolidFillButton - Large")

// 状態グループ別
#Preview("RadioButton - Basic States")
#Preview("RadioButton - Focus States")

// スタイル別
#Preview("ChipLabel - Default Style")
#Preview("ChipLabel - Outline Style")
```

### スナップショット高さのガイドライン

1つのPreviewに収めるバリエーション数の目安:

- **縦並び（VStack）**: 最大8-10要素
- **グリッド（LazyVGrid）**: 2列 × 4-5行
- **推奨高さ**: 800px以内

### メタデータ抽出パターンの更新

`prepare_snapshot_catalog.py`で認識すべき新パターン:

```python
# 既存パターン
r"^(\w+)_(\w+)_(\w+)_\d+\.\d+\.png$"  # Component_variant_state_0.1.png

# 新規パターン（ハイフン区切り）
r"^(\w+)-(\w+)_\d+\.\d+\.png$"         # Component-Variant_0.1.png
r"^(\w+)-(\w+)-(\w+)_\d+\.\d+\.png$"   # Component-Variant-State_0.1.png

# スペース区切りの場合（Prefire名前引数）
r"^(\w+) - (\w+)_\d+\.\d+\.png$"       # "Component - Variant"
```

---

## 📝 検証方法

### テスト手順

1. **Preview分割の実装**: 1つのコンポーネントで試験実装
2. **スナップショット生成**: Xcodeでテスト実行
3. **ファイル確認**: 分割されたPNGが生成されているか
4. **画像内容確認**: 見切れがないか、全バリエーションが表示されているか
5. **スクリプト実行**: メタデータが正しく抽出されるか
6. **Hugo確認**: カタログサイトで正しく表示されるか

### 成功基準

- [ ] 全てのバリエーションが見切れずに表示される
- [ ] 1ファイルあたりのサイズが100KB以下
- [ ] コンポーネントごとにグループ化して表示される
- [ ] バリアント名でフィルタリング可能
- [ ] 既存のメタデータ抽出機能が正常動作

---

## 🎯 まとめ

### 質問への回答

**[1] コンポーネントごとにどのように #Preview を分解するか**

→ **サイズ・状態・スタイルの軸で分割**:
- Button系: サイズ別（Small, Medium, Large）
- Checkbox/RadioButton: サイズまたは状態グループ別
- Chip系: スタイル別
- 原則: 1つのPreviewは画面内（800px）に収まる量

**[2] hugo によるUIプレビューサイト構築時にどのように反映するか**

→ **コンポーネント別グループ表示**:
- `by_component`グループをJSON出力に追加
- Hugoレイアウトでコンポーネントセクションを生成
- タブまたはアコーディオンでバリエーションを整理
- メタデータ抽出パターンを拡張（ハイフン/スペース区切り対応）

### 次のアクション

1. Phase 1.1（Button系コンポーネント）から実装開始
2. 1コンポーネントで動作確認
3. 問題なければ他のコンポーネントに展開
4. スクリプトとHugoサイトを並行して改善
