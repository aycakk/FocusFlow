import SwiftUI
import SwiftData

struct TaskDetailSheet: View {
    @Bindable var task: TaskItem
    let viewModel: TasksViewModel

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    private let estimateOptions: [Int?] = [nil, 15, 30, 45, 60, 90]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xxl) {

                    // Title
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text("TITLE".uppercased())
                            .font(AppTheme.Typography.eyebrow)
                            .foregroundStyle(AppTheme.Colors.tertiaryText)
                        TextField("Task title", text: $task.title, axis: .vertical)
                            .font(AppTheme.Typography.headline)
                            .foregroundStyle(AppTheme.Colors.primaryText)
                            .lineLimit(1...4)
                    }

                    // Notes
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text("NOTES".uppercased())
                            .font(AppTheme.Typography.eyebrow)
                            .foregroundStyle(AppTheme.Colors.tertiaryText)
                        TextField("Add a note...", text: Binding(
                            get: { task.notes ?? "" },
                            set: { task.notes = $0.isEmpty ? nil : $0 }
                        ), axis: .vertical)
                        .font(AppTheme.Typography.body)
                        .foregroundStyle(AppTheme.Colors.secondaryText)
                        .lineLimit(3...6)
                    }

                    // Status Picker
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text("STATUS".uppercased())
                            .font(AppTheme.Typography.eyebrow)
                            .foregroundStyle(AppTheme.Colors.tertiaryText)
                        Picker("Status", selection: $task.status) {
                            Text("Inbox").tag(TaskStatus.inbox)
                            Text("Scheduled").tag(TaskStatus.scheduled)
                            Text("Someday").tag(TaskStatus.someday)
                        }
                        .pickerStyle(.segmented)
                    }

                    // Scheduled Date (only when status == .scheduled)
                    if task.status == .scheduled {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            Text("DATE".uppercased())
                                .font(AppTheme.Typography.eyebrow)
                                .foregroundStyle(AppTheme.Colors.tertiaryText)
                            DatePicker(
                                "Scheduled date",
                                selection: Binding(
                                    get: { task.scheduledDate ?? Date() },
                                    set: { task.scheduledDate = $0 }
                                ),
                                displayedComponents: .date
                            )
                            .labelsHidden()
                        }
                    }

                    // Time Estimate
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text("ESTIMATE".uppercased())
                            .font(AppTheme.Typography.eyebrow)
                            .foregroundStyle(AppTheme.Colors.tertiaryText)
                        Picker("Estimate", selection: $task.estimatedMinutes) {
                            Text("None").tag(Optional<Int>.none)
                            ForEach([15, 30, 45, 60, 90], id: \.self) { m in
                                Text("\(m) min").tag(Optional(m))
                            }
                        }
                        .pickerStyle(.menu)
                    }

                    Divider()

                    // Add to Today
                    if !task.isInTodayFocus {
                        Button {
                            viewModel.addToTodayFocus(task, context: context)
                            dismiss()
                        } label: {
                            Label("Add to Today's Focus", systemImage: "scope")
                                .font(AppTheme.Typography.body.weight(.medium))
                                .foregroundStyle(AppTheme.Colors.accent)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .buttonStyle(.plain)
                    } else {
                        Label("In today's focus", systemImage: "checkmark.circle.fill")
                            .font(AppTheme.Typography.body)
                            .foregroundStyle(AppTheme.Colors.success)
                    }

                    Divider()

                    // Delete
                    Button(role: .destructive) {
                        viewModel.deleteTask(task, context: context)
                        dismiss()
                    } label: {
                        Label("Delete task", systemImage: "trash")
                            .font(AppTheme.Typography.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(AppTheme.Spacing.xxl)
            }
            .background(AppTheme.Colors.background)
            .navigationTitle("Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        try? context.save()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}
