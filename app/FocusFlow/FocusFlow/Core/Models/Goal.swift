import Foundation
import SwiftData

@Model
final class Goal {
    var id: UUID
    var title: String            // natural language: "Learn SwiftUI"
    var intention: String?       // why: "to get a job at a better company"
    var targetDate: Date?
    var dailyMinutes: Int        // realistic daily focus time
    var status: GoalStatus
    var createdAt: Date
    var lastReviewedAt: Date?
    var planningAnswers: [String: String]  // AI planning Q&A stored for re-planning

    // Cascading relationship with inverse back-reference on TaskItem.goal
    @Relationship(deleteRule: .cascade, inverse: \TaskItem.goal)
    var tasks: [TaskItem]

    init(
        title: String,
        intention: String? = nil,
        targetDate: Date? = nil,
        dailyMinutes: Int = 60,
        status: GoalStatus = .active,
        planningAnswers: [String: String] = [:]
    ) {
        self.id = UUID()
        self.title = title
        self.intention = intention
        self.targetDate = targetDate
        self.dailyMinutes = dailyMinutes
        self.status = status
        self.createdAt = Date()
        self.lastReviewedAt = nil
        self.planningAnswers = planningAnswers
        self.tasks = []
    }
}

// MARK: - Enum

enum GoalStatus: String, Codable, CaseIterable {
    case active
    case completed
    case paused
    case archived
}
