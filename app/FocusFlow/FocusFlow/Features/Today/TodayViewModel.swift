import Foundation
import SwiftUI
import SwiftData
import Observation

// TodayViewModel.swift
// Handles business logic for the Today screen.
// Does NOT fetch data — @Query lives in the View.
// Does NOT hold ModelContext — it is always passed as a parameter.

@Observable
final class TodayViewModel {

    // MARK: - Date Header

    /// Returns a formatted string like "Wednesday · May 20"
    var dateHeader: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE · MMM d"
        return formatter.string(from: Date())
    }

    // MARK: - Summary Text

    /// Returns a summary like "3 focuses · 1 done" or "All done for today"
    func summary(total: Int, done: Int) -> LocalizedStringKey {
        guard total > 0 else { return "Nothing in focus today" }
        if done >= total { return "All done for today" }
        return "\(total - done) remaining · \(done) done"
    }

    // MARK: - Task Actions

    /// Marks a task as completed and removes it from today's focus.
    /// The task stays in the database — it just leaves the Today screen.
    func completeTask(_ task: TaskItem, context: ModelContext) {
        task.previousStatus = task.status
        task.status = .done
        task.completedAt = Date()
        // Keep it in today's focus so it counts as "done" and the
        // "all done" state can trigger — the status filter hides it
        // from the active cards.
        try? context.save()
        Haptics.success()
    }

    /// Defers a task — it stays in the system but leaves today's focus.
    /// The task status becomes .deferred.
    func deferTask(_ task: TaskItem, context: ModelContext) {
        task.status = .deferred
        task.isInTodayFocus = false
        try? context.save()
        Haptics.light()
    }

    // MARK: - AI Insight Note
    // Sprint 4 will replace this with a real AI-generated note.
    // For now this is a static mock string.

    var aiInsightNote: String {
        "You've been consistent this week. Keep it calm."
    }
}
