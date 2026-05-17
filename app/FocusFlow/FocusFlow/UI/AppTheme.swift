import SwiftUI

enum AppTheme {

    enum Colors {
        static let background = Color("AppBackground")
        static let cardBackground = Color("CardBackground")
        static let accent = Color("Accent")
        static let accentSoft = Color("AccentSoft")
        static let primaryText = Color("PrimaryText")
        static let secondaryText = Color("SecondaryText")
        static let tertiaryText = Color("TertiaryText")

        static let success = Color("Success")
        static let warning = Color(hex: "Warning")
        static let danger = Color(hex: "Danger")
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
