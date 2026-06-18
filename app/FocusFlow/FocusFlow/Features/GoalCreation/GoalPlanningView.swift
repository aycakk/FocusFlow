import SwiftUI
import SwiftData

struct GoalPlanningView: View {

    // Passed in from the creation form
    let goalTitle: String
    let dailyMinutes: Int
    let targetDate: Date?
    let onFinished: () -> Void   // closes the whole creation flow

    @Environment(\.modelContext) private var context
    @State private var goalsViewModel = GoalsViewModel()

    // Swap this for OllamaService in Sprint 4 — nothing else changes.
    private let ai: AIService = OllamaService()

    // MARK: - Flow Phases

    private enum Phase {
        case loadingQuestions
        case answering
        case generating
        case reviewing
    }

    @State private var phase: Phase = .loadingQuestions
    @State private var questions: [PlanningQuestion] = []
    @State private var answers: [String: String] = [:]
    @State private var planTasks: [PlanTask] = []

    // MARK: - Body

    var body: some View {
        ZStack {
            AppTheme.Colors.background.ignoresSafeArea()

            switch phase {
            case .loadingQuestions: loadingView("Thinking about your goal…")
            case .answering:        questionsView
            case .generating:       loadingView("Building your plan…")
            case .reviewing:        reviewView
            }
        }
        .navigationTitle("Plan")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            // Runs once when the view appears: fetch the calm questions.
            questions = await ai.planningQuestions(for: goalTitle)
            phase = .answering
        }
    }

    // MARK: - Loading

    private func loadingView(_ message: String) -> some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            ProgressView()
            Text(message)
                .font(AppTheme.Typography.body)
                .foregroundStyle(AppTheme.Colors.secondaryText)
        }
    }

    // MARK: - Questions

    private var questionsView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xxl) {

                Text("A few calm questions")
                    .font(.system(size: 26, weight: .regular, design: .serif))
                    .foregroundStyle(AppTheme.Colors.primaryText)

                ForEach(questions) { question in
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text(question.prompt)
                            .font(AppTheme.Typography.headline)
                            .foregroundStyle(AppTheme.Colors.primaryText)

                        TextField(question.placeholder, text: Binding(
                            get: { answers[question.key] ?? "" },
                            set: { answers[question.key] = $0 }
                        ), axis: .vertical)
                        .font(AppTheme.Typography.body)
                        .lineLimit(2...4)
                        .padding(AppTheme.Spacing.lg)
                        .background(AppTheme.Colors.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.lg, style: .continuous))
                    }
                }

                Button {
                    Task { await generatePlan() }
                } label: {
                    primaryLabel("Build my plan", enabled: true)
                }
            }
            .padding(AppTheme.Spacing.xxl)
        }
    }

    // MARK: - Review

    private var reviewView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {

                Text("Your plan")
                    .font(.system(size: 26, weight: .regular, design: .serif))
                    .foregroundStyle(AppTheme.Colors.primaryText)

                Text("Remove anything that doesn't fit. This is a suggestion, not a rule.")
                    .font(AppTheme.Typography.body)
                    .foregroundStyle(AppTheme.Colors.secondaryText)

                ForEach(planTasks) { task in
                    HStack(alignment: .top, spacing: AppTheme.Spacing.md) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(task.title)
                                .font(AppTheme.Typography.body)
                                .foregroundStyle(AppTheme.Colors.primaryText)
                            Text("\(task.theme) · \(task.estimatedMinutes) min")
                                .font(AppTheme.Typography.caption)
                                .foregroundStyle(AppTheme.Colors.tertiaryText)
                        }
                        Spacer(minLength: 0)
                        Button {
                            planTasks.removeAll { $0.id == task.id }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(AppTheme.Colors.tertiaryText)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(AppTheme.Spacing.lg)
                    .background(AppTheme.Colors.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.lg, style: .continuous))
                }

                Button {
                    confirmPlan()
                } label: {
                    primaryLabel("Confirm plan", enabled: !planTasks.isEmpty)
                }
                .disabled(planTasks.isEmpty)
                .padding(.top, AppTheme.Spacing.sm)
            }
            .padding(AppTheme.Spacing.xxl)
        }
    }

    // MARK: - Shared Button Label

    private func primaryLabel(_ title: String, enabled: Bool) -> some View {
        Text(title)
            .font(AppTheme.Typography.body.weight(.semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.lg)
            .background(enabled ? AppTheme.Colors.accent : AppTheme.Colors.tertiaryText)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.lg, style: .continuous))
    }

    // MARK: - Actions

    private func generatePlan() async {
        phase = .generating
        planTasks = await ai.generatePlan(
            goalTitle: goalTitle,
            answers: answers,
            dailyMinutes: dailyMinutes
        )
        phase = .reviewing
    }

    private func confirmPlan() {
        goalsViewModel.createGoal(
            title: goalTitle,
            intention: answers["motivation"],
            dailyMinutes: dailyMinutes,
            targetDate: targetDate,
            answers: answers,
            planTasks: planTasks,
            context: context
        )
        onFinished()
    }
}

#Preview {
    NavigationStack {
        GoalPlanningView(
            goalTitle: "Learn SwiftUI",
            dailyMinutes: 60,
            targetDate: nil,
            onFinished: {}
        )
    }
    .modelContainer(PersistenceController.preview.container)
}
