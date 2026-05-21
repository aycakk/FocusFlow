import SwiftUI
import SwiftData

// TodayView.swift
// The emotional center of FocusFlow.
// Shows up to 3 focus tasks for today.

struct TodayView: View {

    @State private var viewModel = TodayViewModel()
    @Environment(\.modelContext) private var context

    // Fetch ALL tasks from SwiftData
    // We filter in Swift below — simpler and more readable than #Predicate
    @Query private var allTasks: [TaskItem]

    // MARK: - Computed Properties

    /// Tasks currently marked as today's focus
    private var focusTasks: [TaskItem] {
        allTasks.filter { $0.isInTodayFocus }
    }

    /// Active focus tasks — not done — maximum 3 shown
    private var activeTasks: [TaskItem] {
        let active = focusTasks.filter { $0.status != .done && $0.status != .deferred }
        return Array(active.prefix(3))
    }

    /// Focus tasks that have been completed today
    private var doneTasks: [TaskItem] {
        focusTasks.filter { $0.status == .done }
    }

    /// True when user has focus tasks AND all of them are done
    private var allDone: Bool {
        !focusTasks.isEmpty && activeTasks.isEmpty
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            // Warm porcelain background — fills the whole screen
            AppTheme.Colors.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    // Date, title, summary
                    headerSection

                    // Main content: cards or completion state
                    if allDone {
                        completionSection
                    } else if activeTasks.isEmpty {
                        emptySection
                    } else {
                        focusSection
                    }

                    // Quiet AI note at the bottom
                    // (Static mock for now — real AI in Sprint 4)
                    if !focusTasks.isEmpty {
                        insightNote
                    }

                    // Extra padding at the very bottom for tab bar clearance
                    Spacer().frame(height: AppTheme.Spacing.huge)
                }
                .padding(.horizontal, AppTheme.Spacing.xxl)
            }
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {

            // Date line — "WEDNESDAY · MAY 20"
            Text(viewModel.dateHeader)
                .font(.system(size: 13, weight: .semibold))
                .kerning(0.4)
                .textCase(.uppercase)
                .foregroundStyle(AppTheme.Colors.accent)
                .padding(.top, AppTheme.Spacing.xxxl)

            // Large "Today" title — weight .regular for calm feel
            Text("Today")
                .font(.system(size: 34, weight: .regular))
                .foregroundStyle(AppTheme.Colors.primaryText)
                .tracking(-0.6)

            // Summary — "2 focuses remaining · 1 done"
            Text(viewModel.summary(
                total: min(focusTasks.count, 3),
                done: doneTasks.count
            ))
            .font(.system(size: 14))
            .foregroundStyle(AppTheme.Colors.secondaryText)
        }
        .padding(.bottom, AppTheme.Spacing.xxxl)
    }

    // MARK: - Focus Cards Section

    private var focusSection: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            ForEach(Array(activeTasks.enumerated()), id: \.element.id) { index, task in
                FocusCardView(
                    task: task,
                    index: index + 1,
                    onComplete: {
                        withAnimation(.easeOut(duration: 0.2)) {
                            viewModel.completeTask(task, context: context)
                        }
                    },
                    onDefer: {
                        withAnimation(.easeOut(duration: 0.2)) {
                            viewModel.deferTask(task, context: context)
                        }
                    }
                )
                // Transition when a card is added or removed
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.96).combined(with: .opacity),
                    removal: .opacity
                ))
            }
        }
        // Animate the list when count changes (card removed after swipe)
        .animation(.easeOut(duration: 0.25), value: activeTasks.count)
    }

    // MARK: - Completion State

    // Shown when all focus tasks are done.
    // No confetti. No celebration. Just a quiet, calm acknowledgment.

    private var completionSection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Spacer().frame(height: AppTheme.Spacing.huge)

            Text("Today's focus is complete.")
                .font(.system(size: 24, weight: .regular))
                .foregroundStyle(AppTheme.Colors.primaryText)
                .multilineTextAlignment(.center)
                .tracking(-0.3)

            Text("Take a breath. The rest can wait.")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(AppTheme.Colors.tertiaryText)
                .multilineTextAlignment(.center)

            Spacer().frame(height: AppTheme.Spacing.huge)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Empty State

    // Shown on first launch before any focus tasks exist.

    private var emptySection: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Spacer().frame(height: AppTheme.Spacing.huge)

            Text("Nothing in focus today.")
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(AppTheme.Colors.secondaryText)
                .multilineTextAlignment(.center)

            Text("Go to Tasks to pick what matters today.")
                .font(.system(size: 14))
                .foregroundStyle(AppTheme.Colors.tertiaryText)
                .multilineTextAlignment(.center)

            Spacer().frame(height: AppTheme.Spacing.huge)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - AI Insight Note

    // Small, quiet, italic note.
    // Mock for Sprint 1. Real AI in Sprint 4.

    private var insightNote: some View {
        HStack(alignment: .firstTextBaseline, spacing: AppTheme.Spacing.sm) {
            Text("✦")
                .font(.system(size: 11))
                .foregroundStyle(AppTheme.Colors.accent)

            Text(viewModel.aiInsightNote)
                .font(.system(size: 13.5))
                .italic()
                .foregroundStyle(AppTheme.Colors.secondaryText)
                .lineSpacing(3)
        }
        .padding(.top, AppTheme.Spacing.xxl)
    }
}

// MARK: - Previews

#Preview("With 3 tasks") {
    let container = PersistenceController.preview.container
    PreviewData.insertSampleTasks(into: container.mainContext)
    return TodayView()
        .modelContainer(container)
}

#Preview("Empty — no tasks") {
    TodayView()
        .modelContainer(PersistenceController.preview.container)
}
