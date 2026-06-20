import UIKit

// Small, calm haptic feedback. Used sparingly — a quiet confirmation,
// never a celebration.

enum Haptics {

    /// A gentle success tap — e.g. completing a task.
    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    /// A light tap — e.g. deferring or reordering.
    static func light() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    /// A soft tap — e.g. restoring a completed task.
    static func soft() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }
}
