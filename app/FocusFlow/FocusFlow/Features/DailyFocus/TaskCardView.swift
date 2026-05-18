import SwiftUI

struct TaskCardView: View {
    let task: FocusTask

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text(task.title)
                .font(.title3.weight(.semibold))
                .foregroundStyle(AppTheme.Colors.primaryText)
                .lineLimit(2)

            Text("\(task.estimatedMinutes) min focus")
                .font(.subheadline)
                .foregroundStyle(AppTheme.Colors.secondaryText)

            PriorityBadge(priority: task.priority)
                .padding(.top, AppTheme.Spacing.xs)
        }
        .padding(AppTheme.Spacing.xl)
        .frame(maxWidth: .infinity, minHeight: 132, alignment: .leading)
        .background(AppTheme.Colors.cardBackground)
        .overlay(
            RoundedRectangle(
                cornerRadius: AppTheme.Radius.xl,
                style: .continuous
            )
            .stroke(.black.opacity(0.035), lineWidth: 1)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: AppTheme.Radius.xl,
                style: .continuous
            )
        )
        .shadow(
            color: .black.opacity(0.035),
            radius: 18,
            x: 0,
            y: 8
        )
    }
}

private struct PriorityBadge: View {
    let priority: Int

    var body: some View {
        Text("Priority \(priority)")
            .font(.caption.weight(.semibold))
            .foregroundStyle(AppTheme.Colors.accent)
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.vertical, AppTheme.Spacing.xs)
            .background(AppTheme.Colors.accentSoft)
            .clipShape(Capsule())
    }
}

#Preview {
    TaskCardView(
        task: FocusTask(
            title: "Build Daily Focus UI",
            priority: 1,
            estimatedMinutes: 45
        )
    )
}
