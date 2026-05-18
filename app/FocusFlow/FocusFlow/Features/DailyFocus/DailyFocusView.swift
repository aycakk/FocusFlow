import SwiftUI
import SwiftData

struct DailyFocusView: View {
    @State private var viewModel = DailyFocusViewModel()
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FocusTask.priority) private var tasks: [FocusTask]
   
    

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    Text("Daily Focus")
                        .font(.largeTitle.weight(.semibold))
                        .foregroundStyle(AppTheme.Colors.primaryText)

                    Text("Top 3 today — nothing more.")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.Colors.secondaryText)
                }
                .padding(.top, AppTheme.Spacing.lg)
                .listRowInsets(
                    EdgeInsets(
                        top: AppTheme.Spacing.xxl,
                        leading: AppTheme.Spacing.xl,
                        bottom: AppTheme.Spacing.md,
                        trailing: AppTheme.Spacing.xl
                    )
                )
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)

                ForEach(viewModel.topTasks(from: tasks)) { task in
                    TaskCardView(task: task)
                        .listRowInsets(
                            EdgeInsets(
                                top: AppTheme.Spacing.sm,
                                leading: AppTheme.Spacing.xl,
                                bottom: AppTheme.Spacing.sm,
                                trailing: AppTheme.Spacing.xl
                            )
                        )
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .swipeActions(edge: .trailing) {
                            Button("Done") {
                                viewModel.markDone(task, context: modelContext)
                            }
                            .tint(.green)
                        }
                        .swipeActions(edge: .leading) {
                            Button("Defer") {
                                viewModel.deferTask(task, context: modelContext)
                            }
                            .tint(.orange)
                        }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(AppTheme.Colors.background)
        .onAppear {
            if tasks.isEmpty {
                MockSprintFactory.makeTasks().forEach { task in
                    modelContext.insert(task)
                }

                try? modelContext.save()
            }
        }
    }
}

#Preview {
    DailyFocusView()
}
