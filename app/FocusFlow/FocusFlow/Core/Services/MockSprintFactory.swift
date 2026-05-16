import Foundation

struct MockSprintFactory {

    static func makeTasks() -> [FocusTask] {
        [
            FocusTask(title: "Review SwiftUI layout"),
            FocusTask(title: "Build Daily Focus screen"),
            FocusTask(title: "Setup SwiftData models"),
            FocusTask(title: "Test navigation flow"),
            FocusTask(title: "Refactor AppTheme")
        ]
    }
}
