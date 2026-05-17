import Foundation

struct MockSprintFactory {

    static func makeTasks() -> [FocusTask] {
        [
            FocusTask(
                title: "Review SwiftUI layout",
                priority: 1,
                estimatedMinutes: 30
            ),
            FocusTask(
                title: "Build Daily Focus screen",
                priority: 2,
                estimatedMinutes: 60
            ),
            FocusTask(
                title: "Setup SwiftData models",
                priority: 3,
                estimatedMinutes: 45
            ),
            FocusTask(
                title: "Test navigation flow",
                priority: 4,
                estimatedMinutes: 20
            ),
            FocusTask(
                title: "Refactor AppTheme",
                priority: 5,
                estimatedMinutes: 25
            )
        ]
    }
}
