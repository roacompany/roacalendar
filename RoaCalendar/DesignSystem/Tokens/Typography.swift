import SwiftUI

// MARK: - 타이포그래피 토큰 (DESIGN.md 기반)

extension Font {
    // Display: 34pt / 800
    static let roaDisplay = Font.system(size: 34, weight: .heavy)

    // Title 1: 28pt / 700
    static let roaTitle1 = Font.system(size: 28, weight: .bold)

    // Title 2: 22pt / 700
    static let roaTitle2 = Font.system(size: 22, weight: .bold)

    // Headline: 17pt / 600
    static let roaHeadline = Font.system(size: 17, weight: .semibold)

    // Body: 17pt / 400
    static let roaBody = Font.system(size: 17, weight: .regular)

    // Caption: 12pt / 500
    static let roaCaption = Font.system(size: 12, weight: .medium)

    // Tabular Nums: 17pt SF Pro tabular
    static let roaTabular = Font.system(size: 17, weight: .regular).monospacedDigit()

    // Large Tabular: 48pt (타이머용)
    static let roaTimerDisplay = Font.system(size: 48, weight: .heavy).monospacedDigit()
}
