import Foundation
import SwiftData

@Model
final class DailySnapshot {

    var id: UUID
    var date: Date
    var createdAt: Date

    var topTaskIDs: [UUID]
    var completedCount: Int
    var focusMinutes: Int

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        createdAt: Date = Date(),
        topTaskIDs: [UUID] = [],
        completedCount: Int = 0,
        focusMinutes: Int = 0
    ) {
        self.id = id
        self.date = date
        self.createdAt = createdAt
        self.topTaskIDs = topTaskIDs
        self.completedCount = completedCount
        self.focusMinutes = focusMinutes
    }
}
