import Foundation
import SwiftData

@Model
final class UserPreferences {
    var defaultDailyMinutes: Int
    var aiSuggestionsEnabled: Bool
    var morningCheckInTime: Date?
    var onboardingCompleted: Bool
    var accentStyle: AccentStyle

    init(
        defaultDailyMinutes: Int = 60,
        aiSuggestionsEnabled: Bool = true,
        morningCheckInTime: Date? = nil,
        onboardingCompleted: Bool = false,
        accentStyle: AccentStyle = .cobalt
    ) {
        self.defaultDailyMinutes = defaultDailyMinutes
        self.aiSuggestionsEnabled = aiSuggestionsEnabled
        self.morningCheckInTime = morningCheckInTime
        self.onboardingCompleted = onboardingCompleted
        self.accentStyle = accentStyle
    }
}

enum AccentStyle: String, Codable, CaseIterable {
    case cobalt
    case slate
    case forest
}
