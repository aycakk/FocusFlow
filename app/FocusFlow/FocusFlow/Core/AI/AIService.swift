import Foundation

// MARK: - Planning Question
// One calm question the AI asks during goal planning.
// e.g. "What's driving this goal?"

struct PlanningQuestion: Identifiable {
    let id = UUID()
    let key: String          // stored in Goal.planningAnswers (e.g. "motivation")
    let prompt: String       // the question shown to the user
    let placeholder: String  // hint text in the answer field
}

// MARK: - Plan Task
// A draft task the AI suggests. Not saved yet — the user reviews these,
// then we turn the confirmed ones into real TaskItem objects.

struct PlanTask: Identifiable {
    let id = UUID()
    let title: String        // natural language: "Build your first SwiftUI screen"
    let theme: String        // grouping label, not a week number: "Foundations"
    let estimatedMinutes: Int
    let priority: Int        // 1–3, AI-assigned importance
}

// MARK: - AIService
// The contract every AI backend must fulfill.
// MockAIService (now) and OllamaService (Sprint 4) both adopt this.

protocol AIService {

    /// 2–3 calm follow-up questions for the given goal.
    func planningQuestions(for goalTitle: String) async -> [PlanningQuestion]

    /// A calm plan of 8–12 tasks, based on the goal and the user's answers.
    func generatePlan(
        goalTitle: String,
        answers: [String: String],
        dailyMinutes: Int
    ) async -> [PlanTask]
}
