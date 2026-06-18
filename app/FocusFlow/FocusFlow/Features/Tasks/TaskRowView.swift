import SwiftUI
import SwiftData

struct TaskRowView: View {

    let task: TaskItem
    let onComplete: () -> Void
    let onDefer: () -> Void
    let onSelect: () -> Void       // opens TaskDetailSheet

    // MARK: - Swipe State
    @State private var dragOffset: CGFloat = 0
    private let threshold: CGFloat = 80

    // MARK: - Body

    var body: some View {
        ZStack {
            swipeBackground
            rowContent
                .offset(x: dragOffset)
                .gesture(swipeGesture)
                .animation(.spring(response: 0.3, dampingFraction: 0.8), value: dragOffset)
        }
    }

    // MARK: - Row Content (main white card layer)

    private var rowContent: some View {
        HStack(alignment: .center, spacing: AppTheme.Spacing.md) {
            checkboxButton
            taskContent
            Spacer(minLength: 0)
            metaBadge
        }
        .padding(.vertical, AppTheme.Spacing.md)
        .padding(.horizontal, AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .contentShape(Rectangle())
        .onTapGesture { onSelect() }
    }

    // MARK: - Checkbox Button

    private var checkboxButton: some View {
        Button(action: onComplete) {
            ZStack {
                Circle()
                    .fill(task.status == .done ? AppTheme.Colors.accent : Color.clear)
                    .frame(width: 22, height: 22)
                Circle()
                    .stroke(
                        task.status == .done
                            ? AppTheme.Colors.accent
                            : AppTheme.Colors.borderStrong,
                        lineWidth: 1.5
                    )
                    .frame(width: 22, height: 22)
                if task.status == .done {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Task Title

    private var taskContent: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(task.title)
                .font(AppTheme.Typography.body)
                .foregroundStyle(
                    task.status == .done
                        ? AppTheme.Colors.tertiaryText
                        : AppTheme.Colors.primaryText
                )
                .strikethrough(task.status == .done, color: AppTheme.Colors.tertiaryText)
                .lineLimit(2)
        }
        .opacity(task.status == .done ? 0.6 : 1.0)
    }

    // MARK: - Meta Badge (date or time estimate)

    @ViewBuilder
    private var metaBadge: some View {
        if let date = task.scheduledDate, task.status == .scheduled {
            Text(date.formatted(.dateTime.month(.abbreviated).day()))
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(AppTheme.Colors.warning)
                .padding(.horizontal, AppTheme.Spacing.sm)
                .padding(.vertical, 4)
                .background(AppTheme.Colors.warningSoft)
                .clipShape(Capsule())
        } else if let minutes = task.estimatedMinutes {
            Text("\(minutes) min")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(AppTheme.Colors.tertiaryText)
        }
    }

    // MARK: - Swipe Background

    // Revealed behind the white card as the user drags.
    // Green on left  → swiping right  → complete
    // Amber on right → swiping left   → defer to Someday

    private var swipeBackground: some View {
        HStack(spacing: 0) {

            // Complete side (left, revealed on right-swipe)
            ZStack(alignment: .leading) {
                AppTheme.Colors.success
                    .opacity(dragOffset > 20 ? 1 : 0)
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .padding(.leading, AppTheme.Spacing.xl)
                    .opacity(dragOffset > 40 ? 1 : 0)
            }

            // Defer side (right, revealed on left-swipe)
            ZStack(alignment: .trailing) {
                AppTheme.Colors.warning
                    .opacity(dragOffset < -20 ? 1 : 0)
                Image(systemName: "archivebox.fill")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .padding(.trailing, AppTheme.Spacing.xl)
                    .opacity(dragOffset < -40 ? 1 : 0)
            }
        }
    }

    // MARK: - Swipe Gesture

    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .local)
            .onChanged { value in
                // Only allow horizontal movement, with slight resistance
                dragOffset = value.translation.width * 0.75
            }
            .onEnded { value in
                if value.translation.width > threshold {
                    // Swiped right far enough → complete
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        dragOffset = 500
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        onComplete()
                    }
                } else if value.translation.width < -threshold {
                    // Swiped left far enough → defer
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        dragOffset = -500
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        onDefer()
                    }
                } else {
                    // Not far enough → snap back
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                        dragOffset = 0
                    }
                }
            }
    }
}

// MARK: - Preview

#Preview {
    let container = PersistenceController.preview.container
    let task = TaskItem(title: "Send invoice to Atlas Co.", status: .inbox, estimatedMinutes: 30)
    container.mainContext.insert(task)
    return TaskRowView(
        task: task,
        onComplete: { print("complete") },
        onDefer: { print("defer") },
        onSelect: { print("select") }
    )
    .modelContainer(container)
    .padding()
    .background(AppTheme.Colors.background)
}
