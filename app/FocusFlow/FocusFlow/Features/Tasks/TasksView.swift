import SwiftUI

struct TasksView: View {

    @State private var viewModel = TasksViewModel()

    var body: some View {
        ZStack {
            AppTheme.Colors.background
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                Text("Tasks")
                    .font(.largeTitle.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.primaryText)

                Text("Inbox, Scheduled and Someday.")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.Colors.secondaryText)

                Spacer()
            }
            .padding(AppTheme.Spacing.xxl)
        }
    }
}

#Preview {
    TasksView()
}
