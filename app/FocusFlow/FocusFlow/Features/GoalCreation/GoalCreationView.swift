import SwiftUI

struct GoalCreationView: View {

    let onFinished: () -> Void   // closes the creation sheet when planning is confirmed

    @State private var goalText = ""
    @State private var selectedDuration = "2 Weeks"
    @State private var selectedFocusDuration = "60 min"
    @State private var showPlanning = false

    @State private var goalsViewModel = GoalsViewModel()

    private let durations = ["1 Week", "2 Weeks", "1 Month"]
    private let focusDurations = ["30 min", "60 min", "90 min"]

    // "60 min" -> 60
    private var dailyMinutes: Int {
        Int(selectedFocusDuration.replacingOccurrences(of: " min", with: "")) ?? 60
    }

    private var targetDate: Date? {
        goalsViewModel.targetDate(forDurationLabel: selectedDuration)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xxl) {

            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text("What do you want to achieve?")
                    .font(.largeTitle.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.primaryText)

                Text("Start with one goal. FocusFlow will help you build a calm plan.")
                    .font(.body)
                    .foregroundStyle(AppTheme.Colors.secondaryText)
            }

            TextField("Learn SwiftUI", text: $goalText)
                .font(.body)
                .padding(AppTheme.Spacing.lg)
                .background(AppTheme.Colors.cardBackground)
                .clipShape(
                    RoundedRectangle(cornerRadius: AppTheme.Radius.lg, style: .continuous)
                )

            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text("Goal Duration")
                    .font(.headline)
                    .foregroundStyle(AppTheme.Colors.primaryText)

                OptionRow(options: durations, selectedOption: $selectedDuration)
            }

            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text("Daily Focus")
                    .font(.headline)
                    .foregroundStyle(AppTheme.Colors.primaryText)

                OptionRow(options: focusDurations, selectedOption: $selectedFocusDuration)
            }

            Spacer()

            Button {
                showPlanning = true
            } label: {
                Text("Start Planning")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.lg)
                    .background(
                        goalText.isEmpty
                        ? AppTheme.Colors.tertiaryText
                        : AppTheme.Colors.accent
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: AppTheme.Radius.lg, style: .continuous)
                    )
            }
            .disabled(goalText.isEmpty)
        }
        .padding(AppTheme.Spacing.xxl)
        .background(AppTheme.Colors.background)
        .navigationTitle("New Goal")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showPlanning) {
            GoalPlanningView(
                goalTitle: goalText,
                dailyMinutes: dailyMinutes,
                targetDate: targetDate,
                onFinished: onFinished
            )
        }
    }
}

// MARK: - Option Row
private struct OptionRow: View {

    let options: [String]
    @Binding var selectedOption: String

    var body: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            ForEach(options, id: \.self) { option in
                Button {
                    selectedOption = option
                } label: {
                    Text(option)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(
                            selectedOption == option
                            ? AppTheme.Colors.accent
                            : AppTheme.Colors.secondaryText
                        )
                        .padding(.vertical, AppTheme.Spacing.md)
                        .frame(maxWidth: .infinity)
                        .background(
                            selectedOption == option
                            ? AppTheme.Colors.accentSoft
                            : AppTheme.Colors.cardBackground
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: AppTheme.Radius.md, style: .continuous)
                        )
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        GoalCreationView(onFinished: {})
    }
}
