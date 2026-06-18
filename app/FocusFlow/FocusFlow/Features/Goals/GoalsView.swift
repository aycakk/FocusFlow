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

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {

            Text(goal.title)
                .font(.system(size: 22, weight: .regular, design: .serif))
                .foregroundStyle(AppTheme.Colors.primaryText)
                .lineLimit(2)

            // Calm progress bar — no percentage number shown.
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(AppTheme.Colors.surfaceMuted)
                    Capsule()
                        .fill(AppTheme.Colors.accent)
                        .frame(width: max(0, geo.size.width * progress))
                }
            }
            .frame(height: 6)

            Text("\(goal.tasks.count) steps")
                .font(AppTheme.Typography.caption)
                .foregroundStyle(AppTheme.Colors.tertiaryText)
        }
        .padding(AppTheme.Spacing.xl)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.Colors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xl, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.Radius.xl, style: .continuous)
                .stroke(AppTheme.Colors.border, lineWidth: 0.5)
        )
    }
}

#Preview {
    GoalsView()
        .modelContainer(PersistenceController.preview.container)
}
