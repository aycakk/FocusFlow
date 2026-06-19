import SwiftUI
import SwiftData

struct GoalDetailView: View {
    let goal: Goal
    let viewModel: GoalsViewModel

    @Environment(\.modelContext) private var context

    // Active tasks grouped by theme (not by week number).
    private var groupedTasks: [(theme: String, tasks: [TaskItem])] {
        let active = goal.tasks.filter { $0.status != .done }
        let groups = Dictionary(grouping: active) { $0.theme ?? "Steps" }
        return groups
            .map { (theme: $0.key, tasks: $0.value) }
            .sorted { $0.theme < $1.theme }
    }

    private var completedTasks: [TaskItem] {
        goal.tasks.filter { $0.status == .done }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xxl) {
                header
                ForEach(groupedTasks, id: \.theme) { group in
                    themeSection(group.theme, tasks: group.tasks)
                }
                if !completedTasks.isEmpty {
                    completedSection
                }
            }
            .padding(AppTheme.Spacing.xxl)
        }
        .background(AppTheme.Colors.background)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Header (serif title + intention + calm progress bar)

    private var header: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text(goal.title)
                .font(.system(size: 30, weight: .semibold))
                .tracking(-0.4)
                .foregroundStyle(AppTheme.Colors.primaryText)

            if let intention = goal.intention, !intention.isEmpty {
                Text(intention)
                    .font(AppTheme.Typography.body)
                    .foregroundStyle(AppTheme.Colors.secondaryText)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(AppTheme.Colors.surfaceMuted)
                    Capsule().fill(AppTheme.Colors.accent)
                        .frame(width: max(0, geo.size.width * viewModel.progress(for: goal)))
                }
            }
            .frame(height: 6)
        }
    }

    // MARK: - Theme Section

    private func themeSection(_ theme: String, tasks: [TaskItem]) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text(theme.uppercased())
                .font(AppTheme.Typography.eyebrow)
                .tracking(AppTheme.Typography.Tracking.eyebrow)
                .foregroundStyle(AppTheme.Colors.tertiaryText)

            VStack(spacing: 0) {
                ForEach(tasks) { task in
                    taskRow(task)
                    if task.id != tasks.last?.id {
                        Divider().padding(.leading, 38)
                    }
                }
            }
            .background(AppTheme.Colors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.lg, style: .continuous))
        }
    }

    private func taskRow(_ task: TaskItem) -> some View {
        Button {
            withAnimation { viewModel.toggleTaskCompletion(task, context: context) }
        } label: {
            HStack(spacing: AppTheme.Spacing.md) {
                Image(systemName: task.status == .done ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(task.status == .done ? AppTheme.Colors.accent : AppTheme.Colors.borderStrong)
                Text(task.title)
                    .font(AppTheme.Typography.body)
                    .foregroundStyle(AppTheme.Colors.primaryText)
                Spacer(minLength: 0)
                if let minutes = task.estimatedMinutes {
                    Text("\(minutes) min")
                        .font(AppTheme.Typography.caption)
                        .foregroundStyle(AppTheme.Colors.tertiaryText)
                }
            }
            .padding(AppTheme.Spacing.lg)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Completed (honored, not deleted)

    private var completedSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("COMPLETED")
                .font(AppTheme.Typography.eyebrow)
                .tracking(AppTheme.Typography.Tracking.eyebrow)
                .foregroundStyle(AppTheme.Colors.tertiaryText)

            ForEach(completedTasks) { task in
                Button {
                    withAnimation { viewModel.toggleTaskCompletion(task, context: context) }
                } label: {
                    HStack(spacing: AppTheme.Spacing.md) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(AppTheme.Colors.success)
                        Text(task.title)
                            .font(AppTheme.Typography.body)
                            .foregroundStyle(AppTheme.Colors.tertiaryText)
                            .strikethrough(true, color: AppTheme.Colors.tertiaryText)
                        Spacer(minLength: 0)
                    }
                    .padding(.vertical, AppTheme.Spacing.xs)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    let container = PersistenceController.preview.container
    let goal = Goal(title: "Learn SwiftUI", intention: "to feel confident building apps")
    container.mainContext.insert(goal)
    let task = TaskItem(title: "Build your first screen", status: .someday,
                        estimatedMinutes: 60, source: .aiGenerated, theme: "Foundations")
    task.goal = goal
    container.mainContext.insert(task)
    return NavigationStack {
        GoalDetailView(goal: goal, viewModel: GoalsViewModel())
    }
    .modelContainer(container)
}
