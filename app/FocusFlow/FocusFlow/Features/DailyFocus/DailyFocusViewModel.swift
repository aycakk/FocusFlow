import Foundation
import Observation
import SwiftData

@Observable
final class DailyFocusViewModel {

    func topTasks(from tasks: [FocusTask]) -> [FocusTask] {
        tasks
            .filter { $0.status != .done }
            .sorted { $0.priority < $1.priority }
            .prefix(3)
            .map { $0 }
    }

    func markDone(_ task: FocusTask, context: ModelContext) {
        task.status = .done
        task.completedAt = Date()
        try? context.save()
    }

    func deferTask(_ task: FocusTask, context: ModelContext) {
        task.status = .deferred
        try? context.save()
    }
}
