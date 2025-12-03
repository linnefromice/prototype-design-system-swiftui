# 📘 DADS Select Box — SwiftUI 実装向け仕様資料

⸻

## 1. コンポーネント概要

本ドキュメントは、デジタル庁デザインシステム（DADS）Select Box を
iOS / SwiftUI 向けに再実装するための仕様資料である。

Web 版で定義されている状態（Default, Focus, Error, Disabled）を
SwiftUI で再現可能な形に変換し、状態ごとの外観・遷移・アクセシビリティ要件を整理する。

⸻

## 2. 状態別 UI 一覧（Matrix）

Select Box の状態ごとに見た目・振る舞い・UI 属性を整理した表。

状態 (State)	枠線	背景	テキスト色	アイコン色	補助テキスト	交互作用
Default	#D0D0D0（薄灰）	White	Black	Gray	なし	通常操作可能
Default : focus	太めの黒枠 (#000000)	White	Black	Black	なし	フォーカスリング表示
Error	Red (#D9534F など)	White	Black	Red	赤字でエラー文を表示	操作可能
Error : focus	Red 枠 + 黒フォーカスリング	White	Black	Red or Black	エラー文を赤字表示	操作可能
Disabled	#E5E5E5	#F2F2F2	#AFAFAF	#AFAFAF	なし	操作不可
Disabled : focus	なし	#F2F2F2	#AFAFAF	#AFAFAF	なし	フォーカス不可

🔍 iOS 特有の注意
	•	Web で存在する hover は iOS では不要（Pointer Interaction は任意）
	•	フォーカスは @FocusState で管理
	•	Error + Focus は二重枠を SwiftUI の重ね描画で再現可能

⸻

## 3. 状態遷移（State Machine）

以下は、Select Box の状態遷移を XState 風に整理したもので、
SwiftUI の Redux/Reducer 構造にもそのまま利用可能。

⸻

### 3.1 XState 風 State Machine 構造

states:
  default:
    on:
      FOCUS: focus.default
      ERROR: error
      DISABLE: disabled

  focus.default:
    on:
      BLUR: default
      ERROR: focus.error
      DISABLE: disabled

  error:
    on:
      FOCUS: focus.error
      FIX: default
      DISABLE: disabled

  focus.error:
    on:
      BLUR: error
      FIX: default
      DISABLE: disabled

  disabled:
    on:
      ENABLE: default


⸻

### 3.2 状態遷移パターン（図示）

Default

Default
 ├─ FOCUS → Focus.Default
 ├─ ERROR → Error
 └─ DISABLE → Disabled

Focus.Default

Focus.Default
 ├─ BLUR → Default
 ├─ ERROR → Focus.Error
 └─ DISABLE → Disabled

Error

Error
 ├─ FOCUS → Focus.Error
 ├─ FIX → Default
 └─ DISABLE → Disabled

Focus.Error

Focus.Error
 ├─ BLUR → Error
 ├─ FIX → Default
 └─ DISABLE → Disabled

Disabled

Disabled
 └─ ENABLE → Default


⸻

## 4. SwiftUI 実装向け Enum 定義

状態は SwiftUI の enum で管理することができる。

enum SelectState {
    case `default`
    case focusDefault
    case error
    case focusError
    case disabled
}

enum SelectEvent {
    case focus
    case blur
    case error
    case fix
    case disable
    case enable
}

Reducer を書く場合にもそのまま利用可能。

⸻

## 5. 外観変化のポイント（SwiftUI 実装指針）

● 枠線
	•	通常：1px
	•	Focus：2px 黒
	•	Error：1px 赤
	•	Error + Focus：1px 赤 + 外側に太枠黒

● 背景
	•	Default：White
	•	Disabled：#F2F2F2

● アイコン（▼）
	•	SwiftUI の SF Symbol（ex: chevron.down）で再現
	•	Error 時は red
	•	Disabled 時は gray.opacity(0.4)

● 補助テキスト（エラー文）
	•	.font(.caption)
	•	.foregroundColor(.red)
	•	Select Box の直下に配置

⸻

## 6. アクセシビリティ要件（A11y）
	•	accessibilityLabel で項目名を提供
	•	accessibilityValue で選択中の値を提供
	•	Error 時は accessibilityHint にエラー内容を反映
	•	Disabled の場合は accessibilityHidden(true)

Web の aria-invalid 相当は状態に応じて VoiceOver にヒントで対応。

⸻

## 7. iOS / Web の差分まとめ

要素	Web（DADS）	iOS（SwiftUI 実装）
hover	あり	基本なし
focus	フォーカスリング強調	@FocusState で再現
error のフォーカスリング	二重リング	重ね描画で対応
ドロップダウン	HTML <select>	Menu / Picker / カスタムView
クリック操作	マウス	タップ操作
