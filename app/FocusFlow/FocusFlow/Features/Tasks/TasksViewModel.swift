import Foundation
import SwiftData
import Observation

@Observable
final class TasksViewModel {

    func taskCountSummary(inbox: Int, scheduled: Int) -> String {
        let open = inbox + scheduled
        guard open > 0 else { return "No open tasks" }
        if scheduled == 0 { return "\(open) in inbox" }
        return "\(open) open · \(scheduled) scheduled"
    }

    func addTask(title: String, context: ModelContext) {
        let trimmed = title.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        let task = TaskItem(title: trimmed, status: .inbox)
        context.insert(task)
        try? context.save()
    }

    func completeTask(_ task: TaskItem, context: ModelContext) {
        task.status = .done
        task.completedAt = Date()
        task.isInTodayFocus = false
        try? context.save()
    }

    func deferTask(_ task: TaskItem, context: ModelContext) {
        task.status = .someday
        task.isInTodayFocus = false
        try? context.save()
    }

    func addToTodayFocus(_ task: TaskItem, context: ModelContext) {
        task.isInTodayFocus = true
        try? context.save()
    }

    func deleteTask(_ task: TaskItem, context: ModelContext) {
        task.isInTodayFocus = false
        context.delete(task)
        try? context.save()
    }
}
