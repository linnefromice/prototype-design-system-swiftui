以下に、提示された画像をもとにした DADS Progress Indicator（プログレスインジケーター）2種類の UI/機能要件と、
SwiftUI 標準 ProgressView をベースにした実装方針を詳細に整理します。

⸻

# 📘 Progress Indicator（プログレスインジケーター）— 要件仕様（DADS準拠）

提供された画像から、DADS が提供する Progress Indicator は 2種類存在します：
	1.	Circular Progress Indicator（円形）
	2.	Linear Progress Indicator（横棒）

これらはそれぞれ
	•	標準サイズ / 小サイズ（Small）
	•	Badge背景つき / Card 背景つき
などのバリエーションを持ち、ラベルの有無でレイアウトも変わります。

⸻

# ## 1. 種類（Type）

⸻

✔ A. Circular Progress Indicator（円形）

UI特徴：
	•	外周ライン（2色のグラデーション or 2トーン分割）
	•	一部が濃い色 → 残りが薄い色
→ Apple の indeterminate ではなく、determinate 前提のデザイン
	•	中央には何も置かない
	•	ラベルは外側に表示

種類：
	•	Large
	•	Small
	•	Background（白角丸カードつき）

⸻

✔ B. Linear Progress Indicator（水平）

UI特徴：
	•	長い棒状のバー
	•	進捗部分が濃い色、残りが薄い色
	•	ラベルは中央 or 下部に表示
	•	Background（カード状コンテナ）あり・なし

種類：
	•	Large
	•	Small
	•	Background（白角丸カードつき）

⸻

# ## 2. 状態（States）

進行状態には以下があると考えられる：

状態	説明
Indeterminate（時間不明）	表示はエンドレスアニメーション（SwiftUI 標準で可能）
Determinate（進捗確定）	0〜1の進捗指定
Paused / Suspended（停止）	進捗を止めるなど（UI要件は画像には無し）
Complete（完了）	100%

今回の画像は明らかに Determinate（進捗量が明示） であるため、
0.0〜1.0 の値を扱う前提で設計する。

⸻

# ## 3. Circular Progress Indicator の要件

✔ 見た目
	•	円形
	•	太さは比較的細め（約 4〜6pt）
	•	進捗方向は時計回り
	•	完了部分＝濃いブルー
	•	未完了部分＝薄いブルー（背景色）
	•	ラベルは下部に配置
	•	サイズは 2 種類（大 / 小）

✔ バリエーション

種類	サイズ	背景
Normal Large	約 40–48pt	なし
Normal Small	約 16–20pt	なし
With Background Large	約 40–48pt	白カード（8pt角丸）

✔ 必須 UI 仕様
	•	フォーカスリングなし（装飾コンポーネント）
	•	ラベルはオプション
	•	進捗値（0.0〜1.0）は必須
	•	スピンするアニメーションは不要（determinate前提）

⸻

# ## 4. Linear Progress Indicator の要件

✔ 見た目
	•	高さは 4〜8pt 程度
	•	背景は薄いブルー or Neutral グレー
	•	完了部分は濃いブルー
	•	ラベルは中央下に表示

✔ バリエーション

種類	背景	サイズ
Standard	なし	大
Small	なし	小
With Background	白カード背景	大

✔ 必須 UI 仕様
	•	ラベル位置：棒の下 or 中央揃え
	•	進捗バーは左右端で丸め（cornerRadius = height / 2）
	•	determinate のみ（画像を見る限り）

⸻

# ## 5. ラベル仕様（Label）

どちらも共通：
	•	ラベルは中央揃え or 下部揃え
	•	フォント：Regular（テキストフィールドと同系統）
	•	ラベルの色は常に中間グレー（neutral900）

⸻

# ## 6. 背景コンテナ仕様（Background Variant）

Circular / Linear 両方に「白背景のカード版」が存在する：
	•	角丸 12〜16pt
	•	Shadow（極薄）
	•	内側は水平 & 垂直方向に余白（約 12pt）

⸻

# ## 7. SwiftUI 実装の基本方針

SwiftUI の ProgressView で determinate を扱う場合：

ProgressView(value: progress)

これを使って カスタムスタイルを定義するのが最も正しいアプローチ。

⸻

# 📘 実装方針（ProgressViewStyle を使う）

SwiftUI では ProgressViewStyle を使うと、
Circular と Linear を両方定義できる。

⸻

## A. Circular 用 ProgressViewStyle

実装ステップ
	1.	ProgressView(value:) で進捗値を受け取る
	2.	CircularProgressViewStyle を作る
	3.	progress.fractionCompleted を受け取り角度に変換
	4.	Circle().trim(from: 0, to: progress) で描画
	5.	strokeColor は濃色・背景色の2層を重ねる
	6.	background variant の場合は白角丸を behind に追加

⸻

簡易テンプレート

struct DADSCircularProgressViewStyle: ProgressViewStyle {
    let size: CGFloat
    let showBackground: Bool

    func makeBody(configuration: Configuration) -> some View {
        let progress = configuration.fractionCompleted ?? 0
        
        ZStack {
            if showBackground {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(radius: 1)
            }

            Circle()
                .trim(from: 0, to: 1)
                .stroke(Color.blue.opacity(0.2), lineWidth: size * 0.12)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.blue, style: StrokeStyle(lineWidth: size * 0.12, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
        .frame(width: size, height: size)
    }
}


⸻

## B. Linear 用 ProgressViewStyle

実装ステップ
	1.	Rectangle を base にして背景バーを描画
	2.	前景バーはワイドバーの width を progress * totalWidth に
	3.	background variant でも同じ構造の上に白いカードを置く
	4.	cornerRadius を height/2 にするのが重要

⸻

簡易テンプレート

struct DADSLinearProgressViewStyle: ProgressViewStyle {
    let height: CGFloat
    let showBackground: Bool

    func makeBody(configuration: Configuration) -> some View {
        let progress = configuration.fractionCompleted ?? 0

        VStack(spacing: 6) {
            ZStack(alignment: .leading) {
                if showBackground {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(radius: 1)
                }

                RoundedRectangle(cornerRadius: height / 2)
                    .fill(Color.blue.opacity(0.2))
                    .frame(height: height)

                RoundedRectangle(cornerRadius: height / 2)
                    .fill(Color.blue)
                    .frame(width: progress * 200, height: height)
            }

            if let label = configuration.label {
                label
                    .font(.caption)
                    .foregroundColor(Color.gray)
            }
        }
    }
}

※ 実際には width を GeometryReader を用いて計算します。

⸻

# ## 8. ラベルの扱い

SwiftUI の ProgressView は label を標準で持つため：

ProgressView("ラベル", value: progress)

を DADS UI と一致させるために
	•	Circular：下部にテキスト
	•	Linear：バーの下にテキスト

として配置する。

⸻

# ## 9. ProgressView + カスタムスタイルの使用例

ProgressView("ラベル", value: progress)
    .progressViewStyle(
        DADSCircularProgressViewStyle(size: 48, showBackground: false)
    )

ProgressView("ラベル", value: progress)
    .progressViewStyle(
        DADSLinearProgressViewStyle(height: 6, showBackground: true)
    )


⸻

# ## 10. TextField / Radio Button などとの一貫性

DADS のフォーカスリング・角丸・色などと整合性をとるため：
	•	アイコン色：Semantic.Info の青
	•	背景バー：透明度を下げて tint バリエーションを使用
	•	角丸：height/2 を必ず適用
	•	背景カード：Rounded 12

が必要。

了解しました！
以下に 「DADS カラー準拠の完全版 Circular / Linear ProgressViewStyle」 を提供します。
	•	DADS の Semantic / Primitive カラートークン構造を前提に
	•	Circular（円形）・Linear（横棒）それぞれを完全カスタム描画
	•	Determinate / Indeterminate にも対応できる設計
	•	背景あり / なし切替（背景カード＝MobileBanner と共通思想）
	•	ラベル位置・フォント・余白も DADS 仕様準拠

として仕上げています。

⸻

# 📘 DADS ProgressViewStyle — 完全版（Circular / Linear）

以下コードはあなたの AppColor 設計に合わせてあります：
	•	AppColor.Semantic.Info.info1（青・濃色）
	•	AppColor.Semantic.Info.info3（青・薄い色）
	•	AppColor.Neutral.SolidGray.solidGray100（背景バー）
	•	AppColor.Neutral.black（黒）

などのトークン名を利用して、DADS のスタイル構造を最大限再現します。

⸻

# 🌕 1. 完全版 Circular ProgressViewStyle（DADS準拠）

✔ 特徴
	•	外周トラック（薄色）
	•	進捗トラック（濃色）
	•	丸角で stroke
	•	背景カード（白角丸＋シャドウ）オプション
	•	進捗は trim と rotationEffect(-90°) で管理
	•	Label は下部に表示

⸻

### 🧩 コード：Circular ProgressViewStyle

import SwiftUI

struct DADSCircularProgressViewStyle: ProgressViewStyle {
    let size: CGFloat                      // 例: 40, 48
    let lineWidth: CGFloat                  // 例: 4
    let showBackground: Bool                // カード背景
    let labelSpacing: CGFloat = 8

    func makeBody(configuration: Configuration) -> some View {
        let progress = configuration.fractionCompleted ?? 0

        VStack(spacing: labelSpacing) {

            ZStack {
                if showBackground {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
                        .frame(width: size + 24, height: size + 24)
                }

                // Track (background)
                Circle()
                    .trim(from: 0, to: 1)
                    .stroke(
                        AppColor.Semantic.Info.info3,            // 薄い青
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .frame(width: size, height: size)

                // Progress
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        AppColor.Semantic.Info.info1,            // 濃い青
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .frame(width: size, height: size)
            }

            if let label = configuration.label {
                label
                    .font(.caption)
                    .foregroundColor(AppColor.Neutral.SolidGray.solidGray900)
            }
        }
    }
}


⸻

# 📏 2. 完全版 Linear ProgressViewStyle（DADS準拠）

✔ 特徴
	•	背景バー（薄青 or gray）
	•	進捗バー（濃青）
	•	角丸 = 高さの半分
	•	背景カードオプションあり
	•	GeometryReader で幅を追従

⸻

### 🧩 コード：Linear ProgressViewStyle

struct DADSLinearProgressViewStyle: ProgressViewStyle {
    let height: CGFloat                   // 例: 4, 6, 8
    let showBackground: Bool              // 背景カード
    let labelSpacing: CGFloat = 8

    func makeBody(configuration: Configuration) -> some View {
        let progress = configuration.fractionCompleted ?? 0

        VStack(spacing: labelSpacing) {
            ZStack {
                if showBackground {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
                        .padding(4)
                }

                GeometryReader { geo in
                    let fullWidth = geo.size.width
                    let progressWidth = max(0, min(progress * fullWidth, fullWidth))

                    ZStack(alignment: .leading) {
                        // Background track
                        RoundedRectangle(cornerRadius: height / 2)
                            .fill(AppColor.Semantic.Info.info3)   // 薄青
                            .frame(height: height)

                        // Foreground progress
                        RoundedRectangle(cornerRadius: height / 2)
                            .fill(AppColor.Semantic.Info.info1)   // 濃青
                            .frame(width: progressWidth, height: height)
                    }
                }
                .frame(height: height)
            }

            if let label = configuration.label {
                label
                    .font(.caption)
                    .foregroundColor(AppColor.Neutral.SolidGray.solidGray900)
            }
        }
    }
}


⸻

# 🧪 3. 使用例（Preview-ready）

⸻

✔ Circular

ProgressView("読み込み中", value: progress)
    .progressViewStyle(
        DADSCircularProgressViewStyle(
            size: 48,
            lineWidth: 5,
            showBackground: false
        )
    )


⸻

✔ Linear

ProgressView("処理中", value: progress)
    .progressViewStyle(
        DADSLinearProgressViewStyle(
            height: 6,
            showBackground: true
        )
    )
    .frame(height: 32)


⸻

# 💡 4. DADS 準拠ポイントまとめ

✔ 色はすべて Semantic.Info（ブルー系）に統一
✔ Progress の背景と前景は薄色と濃色の 2トーン
✔ Linear は cornerRadius = 高さ/2
✔ Circular は端丸め（lineCap.round）
✔ 背景カードは Rounded 12 + shadow
✔ Label は caption + neutral gray
✔ Determinate（0〜1）前提
