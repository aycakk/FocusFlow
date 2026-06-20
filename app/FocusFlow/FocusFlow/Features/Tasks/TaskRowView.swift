import SwiftUI
import SwiftData

struct TaskRowView: View {

    let task: TaskItem
    let onComplete: () -> Void
    let onSelect: () -> Void

    @Environment(\.locale) private var locale

    var body: some View {
        HStack(alignment: .center, spacing: AppTheme.Spacing.md) {
            checkboxButton
            taskContent
            Spacer(minLength: 0)
            metaBadge
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
        .onTapGesture { onSelect() }
    }

    // MARK: - Checkbox (green when done)

    private var checkboxButton: some View {
        Button(action: onComplete) {
            ZStack {
                Circle()
                    .fill(task.status == .done ? AppTheme.Colors.success : Color.clear)
                    .frame(width: 22, height: 22)
                Circle()
                    .stroke(
                        task.status == .done ? AppTheme.Colors.success : AppTheme.Colors.borderStrong,
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

    // MARK: - Title

    private var taskContent: some View {
        Text(task.title)
            .font(.system(size: 16, weight: .regular))
            .foregroundStyle(task.status == .done ? AppTheme.Colors.tertiaryText : AppTheme.Colors.primaryText)
            .strikethrough(task.status == .done, color: AppTheme.Colors.tertiaryText)
            .lineLimit(2)
    }

    // MARK: - Meta badge (date or time estimate)

    // Only show a badge when it adds information the section header doesn't.
    @ViewBuilder
    private var metaBadge: some View {
        if task.isInTodayFocus && task.status != .done {
            badge(Text("TODAY"), bg: AppTheme.Colors.accentSoft, fg: AppTheme.Colors.accent)
        } else if task.status == .scheduled, let date = task.scheduledDate {
            badge(Text(date.formatted(.dateTime.weekday(.abbreviated).locale(locale)).uppercased()),
                  bg: AppTheme.Colors.warningSoft, fg: AppTheme.Colors.warning)
        } else if let minutes = task.estimatedMinutes {
            Text("\(minutes) min")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(AppTheme.Colors.tertiaryText)
        }
    }

    private func badge(_ text: Text, bg: Color, fg: Color) -> some View {
        text
            .font(.system(size: 11, weight: .semibold))
            .tracking(0.3)
            .foregroundStyle(fg)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(bg)
            .clipShape(Capsule())
    }
}

#Preview {
    let container = PersistenceController.preview.container
    let task = TaskItem(title: "Send invoice to Atlas Co.", status: .inbox, estimatedMinutes: 30)
    container.mainContext.insert(task)
    return List {
        TaskRowView(task: task, onComplete: {}, onSelect: {})
    }
    .modelContainer(container)
}
