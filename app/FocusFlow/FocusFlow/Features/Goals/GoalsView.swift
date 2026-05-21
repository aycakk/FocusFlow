import SwiftUI

struct GoalsView: View {

    @State private var viewModel = GoalsViewModel()

    var body: some View {
        ZStack {
            AppTheme.Colors.background
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                Text("Goals")
                    .font(.largeTitle.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.primaryText)

                Text("Your active goals will appear here.")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.Colors.secondaryText)

                Spacer()
            }
            .padding(AppTheme.Spacing.xxl)
        }
    }
}

#Preview {
    GoalsView()
}
