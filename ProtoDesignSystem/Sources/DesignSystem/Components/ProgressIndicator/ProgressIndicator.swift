import SwiftUI

// MARK: - Circular ProgressViewStyle

public struct DADSCircularProgressViewStyle: ProgressViewStyle {
    let size: CGFloat
    let lineWidth: CGFloat
    let showBackground: Bool
    let labelSpacing: CGFloat = 8

    public init(size: CGFloat = 48, lineWidth: CGFloat = 5, showBackground: Bool = false) {
        self.size = size
        self.lineWidth = lineWidth
        self.showBackground = showBackground
    }

    public func makeBody(configuration: Configuration) -> some View {
        let progress = configuration.fractionCompleted ?? 0

        VStack(spacing: labelSpacing) {
            ZStack {
                if showBackground {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColor.Neutral.white)
                        .shadow(color: AppColor.Neutral.black.opacity(0.08), radius: 4, y: 2)
                        .frame(width: size + 24, height: size + 24)
                }

                // Track (background)
                Circle()
                    .trim(from: 0, to: 1)
                    .stroke(
                        AppColor.Primitive.Blue.blue200,
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .frame(width: size, height: size)

                // Progress
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        AppColor.Primitive.Blue.blue700,
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
        .accessibilityElement(children: .combine)
        .accessibilityLabel(configuration.label != nil ? "" : "プログレスインジケーター")
        .accessibilityValue("\(Int(progress * 100))パーセント完了")
    }
}

// MARK: - Linear ProgressViewStyle

public struct DADSLinearProgressViewStyle: ProgressViewStyle {
    let height: CGFloat
    let showBackground: Bool
    let labelSpacing: CGFloat = 8

    public init(height: CGFloat = 6, showBackground: Bool = false) {
        self.height = height
        self.showBackground = showBackground
    }

    public func makeBody(configuration: Configuration) -> some View {
        let progress = configuration.fractionCompleted ?? 0

        VStack(spacing: labelSpacing) {
            ZStack {
                if showBackground {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColor.Neutral.white)
                        .shadow(color: AppColor.Neutral.black.opacity(0.08), radius: 4, y: 2)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                }

                GeometryReader { geo in
                    let fullWidth = showBackground ? geo.size.width - 32 : geo.size.width
                    let progressWidth = max(0, min(progress * fullWidth, fullWidth))

                    ZStack(alignment: .leading) {
                        // Background track
                        RoundedRectangle(cornerRadius: height / 2)
                            .fill(AppColor.Primitive.Blue.blue200)
                            .frame(width: fullWidth, height: height)

                        // Foreground progress
                        RoundedRectangle(cornerRadius: height / 2)
                            .fill(AppColor.Primitive.Blue.blue700)
                            .frame(width: progressWidth, height: height)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, showBackground ? 16 : 0)
                }
                .frame(height: height)
            }

            if let label = configuration.label {
                label
                    .font(.caption)
                    .foregroundColor(AppColor.Neutral.SolidGray.solidGray900)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(configuration.label != nil ? "" : "プログレスインジケーター")
        .accessibilityValue("\(Int(progress * 100))パーセント完了")
    }
}

// MARK: - Convenience Extensions

extension ProgressViewStyle where Self == DADSCircularProgressViewStyle {
    public static var dadsCircular: DADSCircularProgressViewStyle {
        DADSCircularProgressViewStyle()
    }

    public static func dadsCircular(size: CGFloat, lineWidth: CGFloat = 5, showBackground: Bool = false) -> DADSCircularProgressViewStyle {
        DADSCircularProgressViewStyle(size: size, lineWidth: lineWidth, showBackground: showBackground)
    }
}

extension ProgressViewStyle where Self == DADSLinearProgressViewStyle {
    public static var dadsLinear: DADSLinearProgressViewStyle {
        DADSLinearProgressViewStyle()
    }

    public static func dadsLinear(height: CGFloat, showBackground: Bool = false) -> DADSLinearProgressViewStyle {
        DADSLinearProgressViewStyle(height: height, showBackground: showBackground)
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(alignment: .leading, spacing: 40) {
            Text("Circular Progress Indicator")
                .font(.title.bold())

            VStack(spacing: 24) {
                // Large
                HStack(spacing: 20) {
                    Text("Large")
                        .frame(width: 120, alignment: .trailing)
                        .font(.caption)

                    ProgressView("ラベル", value: 0.7)
                        .progressViewStyle(
                            DADSCircularProgressViewStyle(size: 48, lineWidth: 5)
                        )
                }

                // Small
                HStack(spacing: 20) {
                    Text("Small")
                        .frame(width: 120, alignment: .trailing)
                        .font(.caption)

                    ProgressView("ラベル", value: 0.7)
                        .progressViewStyle(
                            DADSCircularProgressViewStyle(size: 20, lineWidth: 3)
                        )
                }

                // With Background
                HStack(spacing: 20) {
                    Text("With Background")
                        .frame(width: 120, alignment: .trailing)
                        .font(.caption)

                    ProgressView("ラベル", value: 0.7)
                        .progressViewStyle(
                            DADSCircularProgressViewStyle(size: 48, lineWidth: 5, showBackground: true)
                        )
                }
            }

            Divider()
                .padding(.vertical)

            Text("Linear Progress Indicator")
                .font(.title.bold())

            VStack(spacing: 24) {
                // Large
                VStack(alignment: .leading, spacing: 8) {
                    Text("Large")
                        .font(.caption)

                    ProgressView("ラベル", value: 0.7)
                        .progressViewStyle(
                            DADSLinearProgressViewStyle(height: 8)
                        )
                        .frame(height: 32)
                }

                // Small
                VStack(alignment: .leading, spacing: 8) {
                    Text("Small")
                        .font(.caption)

                    ProgressView("ラベル", value: 0.7)
                        .progressViewStyle(
                            DADSLinearProgressViewStyle(height: 4)
                        )
                        .frame(height: 28)
                }

                // With Background
                VStack(alignment: .leading, spacing: 8) {
                    Text("With Background")
                        .font(.caption)

                    ProgressView("ラベル", value: 0.7)
                        .progressViewStyle(
                            DADSLinearProgressViewStyle(height: 8, showBackground: true)
                        )
                        .frame(height: 48)
                }
            }

            Divider()
                .padding(.vertical)

            Text("Different Progress Values")
                .font(.title.bold())

            VStack(spacing: 24) {
                // Circular - various progress
                HStack(spacing: 16) {
                    ProgressView("0%", value: 0.0)
                        .progressViewStyle(.dadsCircular(size: 40))

                    ProgressView("25%", value: 0.25)
                        .progressViewStyle(.dadsCircular(size: 40))

                    ProgressView("50%", value: 0.5)
                        .progressViewStyle(.dadsCircular(size: 40))

                    ProgressView("75%", value: 0.75)
                        .progressViewStyle(.dadsCircular(size: 40))

                    ProgressView("100%", value: 1.0)
                        .progressViewStyle(.dadsCircular(size: 40))
                }

                // Linear - various progress
                VStack(spacing: 12) {
                    ProgressView("0%", value: 0.0)
                        .progressViewStyle(.dadsLinear(height: 6))
                        .frame(height: 28)

                    ProgressView("25%", value: 0.25)
                        .progressViewStyle(.dadsLinear(height: 6))
                        .frame(height: 28)

                    ProgressView("50%", value: 0.5)
                        .progressViewStyle(.dadsLinear(height: 6))
                        .frame(height: 28)

                    ProgressView("75%", value: 0.75)
                        .progressViewStyle(.dadsLinear(height: 6))
                        .frame(height: 28)

                    ProgressView("100%", value: 1.0)
                        .progressViewStyle(.dadsLinear(height: 6))
                        .frame(height: 28)
                }
            }

            Divider()
                .padding(.vertical)

            Text("Without Labels")
                .font(.title.bold())

            VStack(spacing: 24) {
                HStack(spacing: 16) {
                    ProgressView(value: 0.3)
                        .progressViewStyle(.dadsCircular(size: 48))

                    ProgressView(value: 0.6)
                        .progressViewStyle(.dadsCircular(size: 48))

                    ProgressView(value: 0.9)
                        .progressViewStyle(.dadsCircular(size: 48))
                }

                VStack(spacing: 12) {
                    ProgressView(value: 0.3)
                        .progressViewStyle(.dadsLinear(height: 8))
                        .frame(height: 16)

                    ProgressView(value: 0.6)
                        .progressViewStyle(.dadsLinear(height: 8))
                        .frame(height: 16)

                    ProgressView(value: 0.9)
                        .progressViewStyle(.dadsLinear(height: 8))
                        .frame(height: 16)
                }
            }
        }
        .padding()
    }
    .preferredColorScheme(.light)
}
