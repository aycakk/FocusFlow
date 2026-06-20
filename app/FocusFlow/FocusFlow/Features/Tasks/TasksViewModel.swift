import Foundation
import SwiftUI
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

        // Find the current highest sortOrder so the new task goes to the bottom.
        var descriptor = FetchDescriptor<TaskItem>(
            sortBy: [SortDescriptor(\.sortOrder, order: .reverse)]
        )
        descriptor.fetchLimit = 1
        let maxOrder = (try? context.fetch(descriptor))?.first?.sortOrder ?? 0

        let task = TaskItem(title: trimmed, status: .inbox)
        task.sortOrder = maxOrder + 1
        context.insert(task)
        try? context.save()
    }

    /// Reorder a section's tasks after a drag, then renumber their sortOrder.
    func move(_ tasks: [TaskItem], from source: IndexSet, to destination: Int, context: ModelContext) {
        var reordered = tasks
        reordered.move(fromOffsets: source, toOffset: destination)
        for (index, task) in reordered.enumerated() {
            task.sortOrder = index
        }
        try? context.save()
        Haptics.light()
    }

    func completeTask(_ task: TaskItem, context: ModelContext) {
        task.previousStatus = task.status
        task.previousInTodayFocus = task.isInTodayFocus
        task.status = .done
        task.completedAt = Date()
        task.isInTodayFocus = false
        try? context.save()
        Haptics.success()
    }
    
    func uncompleteTask(_ task: TaskItem, context: ModelContext) {
        task.status = task.previousStatus ?? .inbox
        task.isInTodayFocus = task.previousInTodayFocus   // back to Today if it was
        task.previousStatus = nil
        task.previousInTodayFocus = false
        task.completedAt = nil
        try? context.save()
        Haptics.soft()
    }
    
    func deferTask(_ task: TaskItem, context: ModelContext) {
        task.status = .someday
        task.isInTodayFocus = false
        try? context.save()
        Haptics.light()
    }

    func addToTodayFocus(_ task: TaskItem, context: ModelContext) {
        task.isInTodayFocus = true
        try? context.save()
    }

    func deleteTask(_ task: TaskItem, context: ModelContext) {
        task.isInTodayFocus = false
        context.delete(task)
        try? context.save()
        Haptics.light()
    }
}
