import SwiftUI
import SwiftData

struct GoalsView: View {

    @State private var viewModel = GoalsViewModel()
    @Environment(\.modelContext) private var context

    @Query(sort: \Goal.createdAt, order: .reverse) private var goals: [Goal]

    @State private var showingCreation = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()

                if goals.isEmpty {
                    emptyState
                } else {
                    goalList
                }
            }
            .navigationTitle("Goals")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingCreation = true
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                    }
                }
            }
            .sheet(isPresented: $showingCreation) {
                NavigationStack {
                    GoalCreationView(onFinished: { showingCreation = false })
                }
            }
        }
    }

    // MARK: - Goal List

    private var goalList: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.lg) {
                ForEach(goals) { goal in
                    NavigationLink {
                   GoalDetailView(goal: goal, viewModel: viewModel)
                    } label: {
                        GoalCard(goal: goal, progress: viewModel.progress(for: goal))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(AppTheme.Spacing.xxl)
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: "target")
                .font(.system(size: 44, weight: .light))
                .foregroundStyle(AppTheme.Colors.tertiaryText)

            Text("No goals yet")
                .font(AppTheme.Typography.headline)
                .foregroundStyle(AppTheme.Colors.primaryText)

            Text("Start with one goal. FocusFlow will help you build a calm plan.")
                .font(AppTheme.Typography.body)
                .foregroundStyle(AppTheme.Colors.secondaryText)
                .multilineTextAlignment(.center)

            Button {
                showingCreation = true
            } label: {
                Text("Add a goal")
                    .font(AppTheme.Typography.body.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, AppTheme.Spacing.xl)
                    .padding(.vertical, AppTheme.Spacing.md)
                    .background(AppTheme.Colors.accent)
                    .clipShape(Capsule())
            }
            .padding(.top, AppTheme.Spacing.sm)
        }
        .padding(AppTheme.Spacing.huge)
    }
}

// MARK: - Goal Card

private struct GoalCard: View {
    let goal: Goal
    let progress: Double

    private var pct: Int { Int((progress * 100).rounded()) }

    /// Status badge + matching bar/percent color, UI Kit style.
    private var status: (text: String, bg: Color, fg: Color) {
        if goal.status == .completed {
            return ("DONE", AppTheme.Colors.successSoft, AppTheme.Colors.success)
        } else if progress < 0.15 {
            return ("EARLY", AppTheme.Colors.accentSoft, AppTheme.Colors.accent)
        } else {
            return ("ACTIVE", AppTheme.Colors.successSoft, AppTheme.Colors.success)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Title + step count + status badge
            HStack(alignment: .top, spacing: AppTheme.Spacing.md) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(goal.title)
                        .font(.system(size: 19, weight: .medium))
                        .tracking(-0.25)
                        .foregroundStyle(AppTheme.Colors.primaryText)
                        .lineLimit(2)

                    Text("\(goal.tasks.count) steps")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(AppTheme.Colors.secondaryText)
                }

                Spacer(minLength: 0)

                Text(status.text)
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(0.3)
                    .foregroundStyle(status.fg)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(status.bg)
                    .clipShape(Capsule())
                    .padding(.top, 2)
            }

            // Progress label + percentage + bar
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("PROGRESS")
                        .font(.system(size: 11, weight: .semibold))
                        .tracking(0.4)
                        .foregroundStyle(AppTheme.Colors.tertiaryText)
                    Spacer()
                    Text("\(pct)%")
                        .font(.system(size: 11, weight: .semibold))
                        .tracking(0.4)
                        .foregroundStyle(status.fg)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(AppTheme.Colors.surfaceMuted)
                        Capsule()
                            .fill(status.fg)
                            .frame(width: max(0, geo.size.width * progress))
                    }
                }
                .frame(height: 4)
            }
            .padding(.top, AppTheme.Spacing.xl)
        }
        .padding(.horizontal, 22)
        .padding(.top, 22)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.Colors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(AppTheme.Colors.border, lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.04), radius: 2, x: 0, y: 1)
        .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    GoalsView()
        .modelContainer(PersistenceController.preview.container)
}
