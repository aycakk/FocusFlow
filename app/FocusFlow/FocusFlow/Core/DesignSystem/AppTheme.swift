import SwiftUI
import UIKit

enum AppTheme {

    // MARK: - Colors
    enum Colors {

        // Backgrounds
        static let background       = Color(light: "#F7F8FA", dark: "#121417")
        static let backgroundSoft   = Color(light: "#EDE9E3", dark: "#1A1D21")
        static let backgroundMuted  = Color(light: "#E4DFD8", dark: "#22262B")
        static let cardBackground   = Color(light: "#FFFFFF", dark: "#1C1F24")
        static let surfaceMuted     = Color(light: "#F1F3F6", dark: "#272B31")

        // Accent — cobalt blue (slightly brighter in dark for contrast)
        static let accent           = Color(light: "#2A6FDB", dark: "#5C93F0")
        static let accentStrong     = Color(light: "#1B57C2", dark: "#4C8DFF")
        static let accentSoft        = Color(light: "#E8EFFB", dark: "#1E2A40")
        static let accentMid        = Color(light: "#C5D0FF", dark: "#2E3A52")

        // Text scale
        static let primaryText      = Color(light: "#0E1116", dark: "#F2F4F7")
        static let secondaryText    = Color(light: "#525866", dark: "#A8AEB8")
        static let tertiaryText     = Color(light: "#858C99", dark: "#6E7681")
        static let quaternaryText   = Color(light: "#C2BFB8", dark: "#4A4F57")

        // Semantic
        static let success          = Color(light: "#2E8F66", dark: "#3FB985")
        static let successSoft      = Color(light: "#E4F2EC", dark: "#16271F")
        static let warning          = Color(light: "#B8780C", dark: "#E0A23A")
        static let warningSoft      = Color(light: "#FBF1DC", dark: "#2E2512")
        static let danger           = Color(light: "#D04A3B", dark: "#F0685A")
        static let dangerSoft       = Color(light: "#FDEDF0", dark: "#2E1A1C")

        // Borders — black in light, white in dark, both very faint
        static let border           = Color(light: "#0E1116", dark: "#FFFFFF").opacity(0.08)
        static let borderStrong     = Color(light: "#0E1116", dark: "#FFFFFF").opacity(0.14)
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

// MARK: - Adaptive color (light / dark)
extension Color {
    /// Picks the light or dark hex automatically based on the color scheme.
    init(light: String, dark: String) {
        self = Color(UIColor { traits in
            UIColor(traits.userInterfaceStyle == .dark ? Color(hex: dark) : Color(hex: light))
        })
    }
}
