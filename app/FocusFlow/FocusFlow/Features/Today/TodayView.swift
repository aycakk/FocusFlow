import SwiftUI

struct TodayView: View {

    @State private var viewModel = TodayViewModel()

    var body: some View {
        ZStack {
            AppTheme.Colors.background
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                Text("Today")
                    .font(.largeTitle.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.primaryText)

                Text("A calm place to focus on what matters today.")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.Colors.secondaryText)

                Spacer()
            }
            .padding(AppTheme.Spacing.xxl)
        }
    }
}

#Preview {
    TodayView()
}
