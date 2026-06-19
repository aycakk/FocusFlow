import SwiftUI
import SwiftData

struct TasksView: View {

    @State private var viewModel = TasksViewModel()
    @Environment(\.modelContext) private var context

    @Query private var allTasks: [TaskItem]

    @State private var selectedTask: TaskItem? = nil
    @State private var newTaskText = ""
    @State private var showCompleted = false

    // MARK: - Filters (sorted by manual sortOrder)

    // Manual buckets exclude goal tasks (those live in their own section).
    private var inboxTasks: [TaskItem] {
        allTasks.filter { $0.status == .inbox && $0.goal == nil }.sorted { $0.sortOrder < $1.sortOrder }
    }
    private var scheduledTasks: [TaskItem] {
        allTasks.filter { $0.status == .scheduled && $0.goal == nil }.sorted { $0.sortOrder < $1.sortOrder }
    }
    private var somedayTasks: [TaskItem] {
        allTasks.filter { ($0.status == .someday || $0.status == .deferred) && $0.goal == nil }
            .sorted { $0.sortOrder < $1.sortOrder }
    }
    /// Active tasks that belong to a goal — kept in their own section.
    private var goalTasks: [TaskItem] {
        allTasks.filter { $0.goal != nil && $0.status != .done }
            .sorted { $0.sortOrder < $1.sortOrder }
    }
    private var completedTasks: [TaskItem] {
        allTasks.filter { $0.status == .done }
            .sorted { ($0.completedAt ?? .distantPast) > ($1.completedAt ?? .distantPast) }
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            headerSection
                .padding(.horizontal, AppTheme.Spacing.xxl)

            List {
                reorderableSection("Inbox", inboxTasks)
                reorderableSection("Scheduled", scheduledTasks)
                reorderableSection("Someday", somedayTasks)
                reorderableSection("From Goals", goalTasks)
                completedSection
            }
            .listStyle(.insetGrouped)
            .listSectionSpacing(16)
            .scrollContentBackground(.hidden)
        }
        .background(AppTheme.Colors.background)
        .safeAreaInset(edge: .bottom) {
            QuickAddBar(text: $newTaskText) {
                viewModel.addTask(title: newTaskText, context: context)
                newTaskText = ""
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

            Text(viewModel.taskCountSummary(inbox: inboxTasks.count, scheduled: scheduledTasks.count))
                .font(AppTheme.Typography.caption)
                .foregroundStyle(AppTheme.Colors.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, AppTheme.Spacing.lg)
    }

    // MARK: - Reorderable Section (Inbox / Scheduled / Someday)

    @ViewBuilder
    private func reorderableSection(_ title: String, _ tasks: [TaskItem]) -> some View {
        if !tasks.isEmpty {
            Section {
                ForEach(tasks) { task in
                    TaskRowView(
                        task: task,
                        onComplete: { viewModel.completeTask(task, context: context) },
                        onSelect: { selectedTask = task }
                    )
                    .listRowBackground(AppTheme.Colors.cardBackground)
                    .listRowInsets(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .swipeActions(edge: .leading) {
                        Button {
                            viewModel.completeTask(task, context: context)
                        } label: {
                            Label("Done", systemImage: "checkmark")
                        }
                        .tint(AppTheme.Colors.success)
                    }
                    .swipeActions(edge: .trailing) {
                        Button {
                            viewModel.deferTask(task, context: context)
                        } label: {
                            Label("Someday", systemImage: "archivebox")
                        }
                        .tint(AppTheme.Colors.warning)
                    }
                }
                .onMove { from, to in
                    viewModel.move(tasks, from: from, to: to, context: context)
                }
            } header: {
                sectionHeader(title)
            }
        }
    }

    // MARK: - Completed Section

    // Collapsible — keeps the list short. Collapsed by default.
    @ViewBuilder
    private var completedSection: some View {
        if !completedTasks.isEmpty {
            Section {
                if showCompleted {
                    ForEach(completedTasks) { task in
                        TaskRowView(
                            task: task,
                            onComplete: { viewModel.uncompleteTask(task, context: context) },
                            onSelect: { selectedTask = task }
                        )
                        .listRowBackground(AppTheme.Colors.cardBackground)
                        .listRowInsets(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                        .swipeActions(edge: .trailing) {
                            Button {
                                viewModel.uncompleteTask(task, context: context)
                            } label: {
                                Label("Restore", systemImage: "arrow.uturn.backward")
                            }
                            .tint(AppTheme.Colors.accent)
                        }
                    }
                }
            } header: {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { showCompleted.toggle() }
                } label: {
                    HStack(spacing: 6) {
                        sectionHeader("Completed")
                        Text("\(completedTasks.count)")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(AppTheme.Colors.tertiaryText)
                        Spacer()
                        Image(systemName: showCompleted ? "chevron.down" : "chevron.right")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(AppTheme.Colors.tertiaryText)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title.uppercased())
            .font(AppTheme.Typography.eyebrow)
            .tracking(AppTheme.Typography.Tracking.eyebrow)
            .foregroundStyle(AppTheme.Colors.tertiaryText)
    }
}

#Preview("With tasks") {
    let container = PersistenceController.preview.container
    PreviewData.insertSampleTasksAllSections(into: container.mainContext)
    return TasksView().modelContainer(container)
}

#Preview("Empty") {
    TasksView().modelContainer(PersistenceController.preview.container)
}
