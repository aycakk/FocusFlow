import SwiftUI

enum AppTheme {

    // MARK: - Colors
    enum Colors {

        // Backgrounds
        static let background       = Color(hex: "#F7F8FA") // light grey-white
        static let backgroundSoft   = Color(hex: "#EDE9E3") // warm tint (kept for future use)
        static let backgroundMuted  = Color(hex: "#E4DFD8") // warm tint 2
        static let cardBackground   = Color(hex: "#FFFFFF")
        static let surfaceMuted     = Color(hex: "#F1F3F6") // tracks, hairline fills

        // Accent — cobalt blue
        static let accent           = Color(hex: "#2A6FDB")
        static let accentStrong     = Color(hex: "#1B57C2") // darker cobalt
        static let accentSoft       = Color(hex: "#E8EFFB") // tinted fill
        static let accentMid        = Color(hex: "#C5D0FF") // mid tint (kept)

        // Text scale
        static let primaryText      = Color(hex: "#0E1116")
        static let secondaryText    = Color(hex: "#525866")
        static let tertiaryText     = Color(hex: "#858C99")
        static let quaternaryText   = Color(hex: "#C2BFB8") // kept for future

        // Semantic
        static let success          = Color(hex: "#2E8F66")
        static let successSoft      = Color(hex: "#E4F2EC")
        static let warning          = Color(hex: "#B8780C")
        static let warningSoft      = Color(hex: "#FBF1DC")
        static let danger           = Color(hex: "#D04A3B")
        static let dangerSoft       = Color(hex: "#FDEDF0")

        // Borders — base is primaryText (#0E1116)
        static let border           = Color(hex: "#0E1116").opacity(0.08)
        static let borderStrong     = Color(hex: "#0E1116").opacity(0.12)
    }

    // MARK: - Typography
    enum Typography {
        static let display  = Font.system(size: 40, weight: .regular)
        static let titleL   = Font.system(size: 34, weight: .regular)
        static let titleM   = Font.system(size: 28, weight: .medium)
        static let headline = Font.system(size: 19, weight: .medium)
        static let body     = Font.system(size: 15, weight: .regular)
        static let caption  = Font.system(size: 13, weight: .medium)
        static let eyebrow  = Font.system(size: 11, weight: .bold)

        /// Letter-spacing values — apply with .tracking(AppTheme.Typography.Tracking.titleL)
        enum Tracking {
            static let display:  CGFloat = -0.8
            static let titleL:   CGFloat = -0.6
            static let titleM:   CGFloat = -0.5
            static let headline: CGFloat = -0.25
            static let body:     CGFloat =  0.0
            static let caption:  CGFloat =  0.1
            static let eyebrow:  CGFloat =  1.4
        }
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
        static let xl:   CGFloat = 22   // UI Kit geometry: radius.xl = 22px
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
