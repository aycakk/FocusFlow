import SwiftUI

enum AppTheme {

    // MARK: - Colors
    enum Colors {

        // Backgrounds
        static let background       = Color(hex: "#F5F3EF") // porcelain
        static let backgroundSoft   = Color(hex: "#EDE9E3") // porcelain2
        static let backgroundMuted  = Color(hex: "#E4DFD8") // porcelain3
        static let cardBackground   = Color(hex: "#FFFFFF")

        // Accent — cobalt
        static let accent           = Color(hex: "#3B5BDB") // cobalt
        static let accentStrong     = Color(hex: "#4C6EF5") // cobalt2
        static let accentSoft       = Color(hex: "#EBF0FF") // cobalt-soft
        static let accentMid        = Color(hex: "#C5D0FF") // cobalt-mid

        // Text — slate scale
        static let primaryText      = Color(hex: "#3A3935") // slate
        static let secondaryText    = Color(hex: "#6B6860") // slate2
        static let tertiaryText     = Color(hex: "#9A9890") // slate3
        static let quaternaryText   = Color(hex: "#C2BFB8") // slate4

        // Semantic
        static let success          = Color(hex: "#2F9E6B")
        static let successSoft      = Color(hex: "#EAFAF2")
        static let warning          = Color(hex: "#C17F24")
        static let warningSoft      = Color(hex: "#FFF3DC")
        static let danger           = Color(hex: "#C0394B")
        static let dangerSoft       = Color(hex: "#FDEDF0")

        // Borders
        static let border           = Color(hex: "#3A3935").opacity(0.08)
        static let borderStrong     = Color(hex: "#3A3935").opacity(0.14)
    }

    // MARK: - Spacing
    enum Spacing {
        static let xs:   CGFloat = 4
        static let sm:   CGFloat = 8
        static let md:   CGFloat = 12
        static let lg:   CGFloat = 16
        static let xl:   CGFloat = 20
        static let xxl:  CGFloat = 24
        static let xxxl: CGFloat = 32
        static let huge: CGFloat = 48
    }

    // MARK: - Radius
    enum Radius {
        static let sm:   CGFloat = 8
        static let md:   CGFloat = 12
        static let lg:   CGFloat = 16
        static let xl:   CGFloat = 20
        static let xxl:  CGFloat = 28
        static let pill: CGFloat = 999
    }
}

// MARK: - Color hex initializer
extension Color {
    init(hex: String) {
        let hex = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let red   = Double((rgb >> 16) & 0xFF) / 255
        let green = Double((rgb >> 8)  & 0xFF) / 255
        let blue  = Double(rgb & 0xFF)          / 255
        self.init(red: red, green: green, blue: blue)
    }
}
