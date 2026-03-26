import SwiftUI

// MARK: - 색상 토큰 (DESIGN.md 기반)

extension Color {
    // Primary
    static let primary600 = Color(hex: "#2563EB")
    static let primary700 = Color(hex: "#1D4ED8")

    // Accent
    static let accent500 = Color(hex: "#F97316")
    static let accent600 = Color(hex: "#EA580C")

    // Background
    static let bgLight = Color(hex: "#FAFAF8")
    static let bgDark = Color(hex: "#191F28")

    // Surface
    static let surfaceLight = Color(hex: "#FFFFFF")
    static let surfaceDark = Color(hex: "#242B35")

    // Semantic
    static let success = Color(hex: "#22C55E")
    static let warning = Color(hex: "#EAB308")
    static let error = Color(hex: "#EF4444")
    static let info = Color(hex: "#3B82F6")

    // Neutral
    static let neutral50 = Color(hex: "#FAFAF8")
    static let neutral100 = Color(hex: "#F5F5F3")
    static let neutral200 = Color(hex: "#E5E5E0")
    static let neutral300 = Color(hex: "#D4D4CF")
    static let neutral400 = Color(hex: "#A3A3A0")
    static let neutral500 = Color(hex: "#737370")
    static let neutral600 = Color(hex: "#525250")
    static let neutral700 = Color(hex: "#404040")
    static let neutral800 = Color(hex: "#262626")
    static let neutral900 = Color(hex: "#1C1C1A")
}

// MARK: - Hex 초기화

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let red = Double((int >> 16) & 0xFF) / 255.0
        let green = Double((int >> 8) & 0xFF) / 255.0
        let blue = Double(int & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}
