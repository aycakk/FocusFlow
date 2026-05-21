import Foundation
import SwiftData

// PreviewData.swift
// Inserts sample data into an in-memory SwiftData container.
// Used only for Xcode Previews — not for production.

@MainActor
struct PreviewData {

    /// Call this inside a #Preview block to seed the preview with focus tasks.
    static func insertSampleTasks(into context: ModelContext) {
        let tasks: [TaskItem] = [
            TaskItem(
                title: "Outline Q3 product narrative",
                status: .scheduled,
                isInTodayFocus: true,
                estimatedMinutes: 60
            ),
            TaskItem(
                title: "Review draft from design team",
                status: .inbox,
                isInTodayFocus: true,
                estimatedMinutes: 45
            ),
            TaskItem(
                title: "Morning walk · 20 min",
                status: .inbox,
                isInTodayFocus: true,
                estimatedMinutes: 20
            ),
        ]
        for task in tasks {
            context.insert(task)
        }
    }
}
