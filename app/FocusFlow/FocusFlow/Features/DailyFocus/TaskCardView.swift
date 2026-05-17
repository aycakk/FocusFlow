//
//  TaskCardView.swift
//  FocusFlow
//
//  Created by Ayça Kaycalı on 17.05.2026.
//

import SwiftUI

struct TaskCardView: View {
    let task: FocusTask
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            Text(task.title)
                .font(.title3.weight(.semibold))
                .foregroundStyle(AppTheme.Colors.primaryText)

            Text("\(task.estimatedMinutes) min focus")
                .font(.subheadline)
                .foregroundStyle(AppTheme.Colors.secondaryText)

            PriorityBadge(priority: task.priority)
        }
        .padding(AppTheme.Spacing.xl)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.Colors.cardBackground)
        .clipShape(
            RoundedRectangle(
                cornerRadius: AppTheme.Radius.xl,
                style: .continuous
            )
        )
        .shadow(
            color: .black.opacity(0.04),
            radius: 12,
            x: 0,
            y: 6
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
