import Foundation
import SwiftData

@Model
final class TaskItem {
    var id: UUID
    var title: String
    var notes: String?
    var status: TaskStatus
    var scheduledDate: Date?
    var completedAt: Date?
    var createdAt: Date
    var priority: Int            // 0 = unset, 1–3 for goal tasks (AI-assigned)
    var isInTodayFocus: Bool
    var estimatedMinutes: Int?
    var source: TaskSource
    var theme: String?
    var previousStatus: TaskStatus?   // remembers status before completion, for restore
    var previousInTodayFocus: Bool = false   // remembers Today focus before completion
    var sortOrder: Int = 0   // manual drag-to-reorder position within a section

    // Inverse relationship to Goal (optional — tasks can be free-floating)
    var goal: Goal?

    init(
        title: String,
        notes: String? = nil,
        status: TaskStatus = .inbox,
        scheduledDate: Date? = nil,
        priority: Int = 0,
        isInTodayFocus: Bool = false,
        estimatedMinutes: Int? = nil,
        source: TaskSource = .user,
        theme: String? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.notes = notes
        self.status = status
        self.scheduledDate = scheduledDate
        self.completedAt = nil
        self.createdAt = Date()
        self.priority = priority
        self.isInTodayFocus = isInTodayFocus
        self.estimatedMinutes = estimatedMinutes
        self.source = source
        self.theme = theme
    }
}

// MARK: - Enums

enum TaskStatus: String, Codable, CaseIterable {
    case inbox
    case scheduled
    case someday
    case done
    case deferred
}

enum TaskSource: String, Codable {
    case user
    case aiGenerated
}
