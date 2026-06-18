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
            ),TaskItem(
                title: "Outline Q4 product narrative",
                status: .scheduled,
                isInTodayFocus: true,
                estimatedMinutes: 60
            )
        ]
        for task in tasks {
            context.insert(task)
        }
    }
    
    
    static func insertSampleTasksAllSections(into context: ModelContext) {
        let tasks: [TaskItem] = [
            // Inbox
            TaskItem(title: "Send invoice to Atlas Co.", status: .inbox),
            TaskItem(title: "Pick up dry cleaning", status: .inbox),
            TaskItem(title: "Read Annie Dillard essay", status: .inbox, estimatedMinutes: 30),
            // Scheduled
            TaskItem(title: "Coffee with Marisol", status: .scheduled,
                     scheduledDate: Calendar.current.date(byAdding: .day, value: 2, to: Date())),
            TaskItem(title: "Quarterly review prep", status: .scheduled,
                     scheduledDate: Calendar.current.date(byAdding: .day, value: 4, to: Date()),
                     estimatedMinutes: 60),
            // Someday
            TaskItem(title: "Plan weekend trip to coast", status: .someday),
            TaskItem(title: "Learn to make sourdough", status: .someday),
           
        ]
        for task in tasks { context.insert(task) }
    }
}
