import SwiftUI
import SwiftData

struct TasksView: View {

    @State private var viewModel = TasksViewModel()
    @Environment(\.modelContext) private var context

    @Query private var allTasks: [TaskItem]

    // Sheet state
    @State private var selectedTask: TaskItem? = nil

    // QuickAddBar state
    @State private var newTaskText = ""

    // MARK: - Computed Properties

    private var inboxTasks: [TaskItem] {
        allTasks.filter { $0.status == .inbox }
    }

    private var scheduledTasks: [TaskItem] {
        allTasks
            .filter { $0.status == .scheduled }
            .sorted { ($0.scheduledDate ?? .distantFuture) < ($1.scheduledDate ?? .distantFuture) }
    }

    private var somedayTasks: [TaskItem] {
        allTasks.filter { $0.status == .someday || $0.status == .deferred }
    }

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .bottom) {
            AppTheme.Colors.background.ignoresSafeArea()

            // Scrollable content
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    headerSection
                    sectionBlock(title: "Inbox",     tasks: inboxTasks)
                    sectionBlock(title: "Scheduled", tasks: scheduledTasks)
                    sectionBlock(title: "Someday",   tasks: somedayTasks)

                    // Bottom padding — clearance for QuickAddBar + tab bar
                    Spacer().frame(height: 140)
                }
                .padding(.horizontal, AppTheme.Spacing.xxl)
            }

            // QuickAddBar pinned above tab bar
            VStack(spacing: 0) {
                QuickAddBar(text: $newTaskText) {
                    viewModel.addTask(title: newTaskText, context: context)
                    newTaskText = ""
                }
                // White fill behind tab bar
                AppTheme.Colors.cardBackground.frame(height: 83)
            }
        }
        .sheet(item: $selectedTask) { task in
            TaskDetailSheet(task: task, viewModel: viewModel)
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("Tasks")
                .font(AppTheme.Typography.titleL)
                .tracking(AppTheme.Typography.Tracking.titleL)
                .foregroundStyle(AppTheme.Colors.primaryText)
                .padding(.top, AppTheme.Spacing.xxxl)

            Text(viewModel.taskCountSummary(
                inbox: inboxTasks.count,
                scheduled: scheduledTasks.count
            ))
            .font(AppTheme.Typography.caption)
            .foregroundStyle(AppTheme.Colors.secondaryText)
        }
        .padding(.bottom, AppTheme.Spacing.xxxl)
    }

    // MARK: - Section Block

    @ViewBuilder
    private func sectionBlock(title: String, tasks: [TaskItem]) -> some View {
        if !tasks.isEmpty {
            VStack(alignment: .leading, spacing: 0) {

                // Section eyebrow label
                Text(title.uppercased())
                    .font(AppTheme.Typography.eyebrow)
                    .tracking(AppTheme.Typography.Tracking.eyebrow)
                    .foregroundStyle(AppTheme.Colors.tertiaryText)
                    .padding(.bottom, AppTheme.Spacing.sm)

                // Card containing all rows
                VStack(spacing: 0) {
                    ForEach(tasks) { task in
                        TaskRowView(
                            task: task,
                            onComplete: {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    viewModel.completeTask(task, context: context)
                                }
                            },
                            onDefer: {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    viewModel.deferTask(task, context: context)
                                }
                            },
                            onSelect: { selectedTask = task }
                        )
                        if task.id != tasks.last?.id {
                            Divider()
                                .padding(.leading, AppTheme.Spacing.xl + 22)
                        }
                    }
                }
                .background(AppTheme.Colors.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xl, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.Radius.xl, style: .continuous)
                        .stroke(AppTheme.Colors.border, lineWidth: 0.5)
                )
                .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 2)
            }
            .padding(.bottom, AppTheme.Spacing.xxxl)
        }
    }
}

// MARK: - Previews

#Preview("With tasks") {
    let container = PersistenceController.preview.container
    PreviewData.insertSampleTasksAllSections(into: container.mainContext)
    return TasksView().modelContainer(container)
}

#Preview("Empty") {
    TasksView().modelContainer(PersistenceController.preview.container)
}
