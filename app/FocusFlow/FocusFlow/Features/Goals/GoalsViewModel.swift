import Foundation
import SwiftData
import Observation

@Observable
final class GoalsViewModel {

    // MARK: - Create

    /// Creates a goal and materializes the confirmed AI plan into real tasks.
    func createGoal(
        title: String,
        intention: String?,
        dailyMinutes: Int,
        targetDate: Date?,
        answers: [String: String],
        planTasks: [PlanTask],
        context: ModelContext
    ) {
        let goal = Goal(
            title: title,
            intention: intention,
            targetDate: targetDate,
            dailyMinutes: dailyMinutes,
            planningAnswers: answers
        )
        context.insert(goal)

        // Turn each draft PlanTask into a persisted TaskItem linked to the goal.
        for (index, plan) in planTasks.enumerated() {
            let task = TaskItem(
                title: plan.title,
                status: .someday,        // plan tasks wait in Someday until scheduled/focused
                priority: plan.priority,
                estimatedMinutes: plan.estimatedMinutes,
                source: .aiGenerated,
                theme: plan.theme
            )
            task.goal = goal
            task.sortOrder = index       // keep the AI plan's order stable
            context.insert(task)
        }

        try? context.save()
    }

    // MARK: - Delete

    func deleteGoal(_ goal: Goal, context: ModelContext) {
        context.delete(goal)   // cascade rule also deletes its tasks
        try? context.save()
    }
    // MARK: - Task Completion

    /// Toggle a goal task done/undone. Drives the progress bar.
    func toggleTaskCompletion(_ task: TaskItem, context: ModelContext) {
        if task.status == .done {
            task.status = .someday
            task.completedAt = nil
        } else {
            task.status = .done
            task.completedAt = Date()
            task.isInTodayFocus = false
        }
        try? context.save()
    }

    // MARK: - Progress

    /// Fraction 0...1 of completed tasks. The UI shows a bar, never a number.
    func progress(for goal: Goal) -> Double {
        let tasks = goal.tasks
        guard !tasks.isEmpty else { return 0 }
        let done = tasks.filter { $0.status == .done }.count
        return Double(done) / Double(tasks.count)
    }

    // MARK: - Helpers

    /// Converts a duration label from the creation form into a target date.
    func targetDate(forDurationLabel label: String, from start: Date = Date()) -> Date? {
        let cal = Calendar.current
        switch label {
        case "1 Week":  return cal.date(byAdding: .day,   value: 7,  to: start)
        case "2 Weeks": return cal.date(byAdding: .day,   value: 14, to: start)
        case "1 Month": return cal.date(byAdding: .month, value: 1,  to: start)
        default:        return nil
        }
    }
}
