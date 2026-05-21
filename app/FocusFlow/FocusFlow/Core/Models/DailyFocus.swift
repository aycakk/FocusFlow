import Foundation
import SwiftData

@Model
final class DailyFocus {
    var date: Date
    var focusTaskIDs: [UUID]
    var completedCount: Int
    var aiInsight: String?
    var wasAISuggested: Bool

    init(
        date: Date = Date(),
        focusTaskIDs: [UUID] = [],
        completedCount: Int = 0,
        aiInsight: String? = nil,
        wasAISuggested: Bool = false
    ) {
        self.date = date
        self.focusTaskIDs = focusTaskIDs
        self.completedCount = completedCount
        self.aiInsight = aiInsight
        self.wasAISuggested = wasAISuggested
    }
}
