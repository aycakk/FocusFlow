import SwiftUI

enum AppTheme {

    enum Colors {
        static let background = Color(hex: "#F7F8FA")
        static let cardBackground = Color(hex: "#FFFFFF")
        static let surfaceMuted = Color(hex: "#F1F3F6")

        static let primaryText = Color(hex: "#0E1116")
        static let secondaryText = Color(hex: "#525866")
        static let tertiaryText = Color(hex: "#858C99")

        static let accent = Color(hex: "#2A6FDB")
        static let accentSoft = Color(hex: "#E8EFFB")

        static let success = Color(hex: "#2E8F66")
        static let warning = Color(hex: "#B8780C")
        static let danger = Color(hex: "#D04A3B")
    }

    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let xxxl: CGFloat = 32
        static let huge: CGFloat = 48
    }

    enum Radius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 22
        static let xxl: CGFloat = 28
        static let pill: CGFloat = 999
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hex)

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255
        let green = Double((rgb >> 8) & 0xFF) / 255
        let blue = Double(rgb & 0xFF) / 255

        self.init(red: red, green: green, blue: blue)
    }
}
