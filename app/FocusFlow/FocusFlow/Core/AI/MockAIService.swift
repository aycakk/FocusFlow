import Foundation

// MARK: - MockAIService
// A fake AI used during all non-AI sprints.
// Returns canned calm questions and a sample plan, with a small
// delay so the UI behaves like the real (async) Ollama service will.

struct MockAIService: AIService {

    // MARK: Planning Questions

    func planningQuestions(for goalTitle: String) async -> [PlanningQuestion] {
        await fakeThinking()

        return [
            PlanningQuestion(
                key: "motivation",
                prompt: "What's driving this goal?",
                placeholder: "e.g. to feel more confident at work"
            ),
            PlanningQuestion(
                key: "time",
                prompt: "How much time can you realistically give per day?",
                placeholder: "e.g. about an hour after dinner"
            ),
            PlanningQuestion(
                key: "hardest",
                prompt: "What feels hardest about starting?",
                placeholder: "e.g. I don't know where to begin"
            )
        ]
    }

    // MARK: Plan Generation

    func generatePlan(
        goalTitle: String,
        answers: [String: String],
        dailyMinutes: Int
    ) async -> [PlanTask] {
        await fakeThinking()

        // A calm, themed sample plan — grouped by theme, not week number.
        return [
            PlanTask(title: "Set aside a quiet place to focus", theme: "Foundations", estimatedMinutes: 15, priority: 1),
            PlanTask(title: "Write down what 'done' looks like", theme: "Foundations", estimatedMinutes: 20, priority: 1),
            PlanTask(title: "Find one trusted resource to learn from", theme: "Foundations", estimatedMinutes: 30, priority: 2),

            PlanTask(title: "Spend one short session exploring the basics", theme: "Getting started", estimatedMinutes: dailyMinutes, priority: 1),
            PlanTask(title: "Take notes on what felt unclear", theme: "Getting started", estimatedMinutes: 20, priority: 2),
            PlanTask(title: "Try a tiny first attempt of your own", theme: "Getting started", estimatedMinutes: dailyMinutes, priority: 1),

            PlanTask(title: "Review what you learned this week", theme: "Building momentum", estimatedMinutes: 30, priority: 2),
            PlanTask(title: "Pick one thing to go deeper on", theme: "Building momentum", estimatedMinutes: dailyMinutes, priority: 2),
            PlanTask(title: "Share your progress with someone", theme: "Building momentum", estimatedMinutes: 15, priority: 3),

            PlanTask(title: "Reflect on what's working and adjust", theme: "Staying steady", estimatedMinutes: 20, priority: 3)
        ]
    }
    
    func insightNote(completedToday: Int, totalToday: Int) async -> String {
        await fakeThinking()
        if totalToday == 0 { return "Nothing in focus yet. A calm start is enough." }
        if completedToday >= totalToday { return "Today's focus is complete. The rest can wait." }
        return "Keeping a small focus is enough for today."
    }

    // MARK: - Helpers

    /// Simulates the latency of a real AI call so the UI's loading
    /// state gets exercised during development.
    private func fakeThinking() async {
        try? await Task.sleep(for: .seconds(1.2))
    }
}
