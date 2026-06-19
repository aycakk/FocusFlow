

import SwiftUI
import SwiftData



// FocusCardView.swift
// Displays a single focus task as a spacious card.
// Supports:
//   - Tap checkbox → complete
//   - Swipe right  → complete
//   - Swipe left   → defer

struct FocusCardView: View {

    let task: TaskItem    // The task to display
    let index: Int        // 1, 2, or 3 — shown as "Focus 1"
    let onComplete: () -> Void
    let onDefer: () -> Void

    // How far the card has been dragged
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        ZStack {
            // Colored background revealed as you drag
            swipeBackground

            // Main white card, offset by drag amount
            cardContent
                .offset(x: dragOffset)
                .gesture(swipeGesture)
                // Smooth spring animation on drag
                .animation(
                    .spring(response: 0.35, dampingFraction: 0.8),
                    value: dragOffset
                )
        }
        // Clip both layers together
        .clipShape(
            RoundedRectangle(cornerRadius: AppTheme.Radius.xl, style: .continuous)
        )
    }

    // MARK: - Main Card Content

    private var cardContent: some View {
        HStack(alignment: .top, spacing: AppTheme.Spacing.lg) {

            // Left column: label + title + meta
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {

                // "FOCUS 1" — small amber label (hidden once done, like the UI Kit)
                if task.status != .done {
                    Text("Focus \(index)")
                        .font(.system(size: 10.5, weight: .semibold))
                        .kerning(0.8)
                        .textCase(.uppercase)
                        .foregroundStyle(AppTheme.Colors.warning)
                        .opacity(0.85)
                        .padding(.bottom, 2)
                }

                // Task title
                Text(task.title)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(
                        task.status == .done
                            ? AppTheme.Colors.tertiaryText
                            : AppTheme.Colors.primaryText
                    )
                    .strikethrough(
                        task.status == .done,
                        color: AppTheme.Colors.tertiaryText
                    )
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)

                // Meta label: time estimate or "Inbox"
                metaLabel
            }

            Spacer(minLength: 0)

            // Right column: tap-to-complete checkbox
            checkboxButton
                .padding(.top, AppTheme.Spacing.lg)
        }
        .padding(AppTheme.Spacing.xxl)
        .background(AppTheme.Colors.cardBackground)
        .overlay(
            // Subtle border
            RoundedRectangle(cornerRadius: AppTheme.Radius.xl, style: .continuous)
                .stroke(AppTheme.Colors.border, lineWidth: 0.5)
        )
        // Fade out when done
        .opacity(task.status == .done ? 0.55 : 1.0)
        // Double shadow for depth (same as UIKit design)
        .shadow(color: .black.opacity(0.04), radius: 2, x: 0, y: 1)
        .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 2)
    }

    // MARK: - Meta Label

    private var metaLabel: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            // Small colored dot
            Circle()
                .fill(metaColor)
                .frame(width: 6, height: 6)

            // Category (goal name) or fallback
            Text(metaText)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(AppTheme.Colors.secondaryText)
        }
        .padding(.top, AppTheme.Spacing.xs)
    }

    /// Dot color — accent when the task belongs to a goal, muted otherwise.
    private var metaColor: Color {
        task.goal != nil ? AppTheme.Colors.accent : AppTheme.Colors.tertiaryText
    }

    /// Shows the goal name as a category (UI Kit style), else the estimate.
    private var metaText: String {
        if let goalTitle = task.goal?.title { return goalTitle }
        if let minutes = task.estimatedMinutes { return "\(minutes) min" }
        return "Inbox"
    }

    // MARK: - Checkbox Button (Tap to Complete)

    private var checkboxButton: some View {
        Button(action: onComplete) {
            ZStack {
                // Fill — only visible when done
                Circle()
                    .fill(task.status == .done ? AppTheme.Colors.accent : Color.clear)
                    .frame(width: 28, height: 28)

                // Stroke — always visible
                Circle()
                    .stroke(
                        task.status == .done
                            ? AppTheme.Colors.accent
                            : AppTheme.Colors.borderStrong,
                        lineWidth: 1.5
                    )
                    .frame(width: 28, height: 28)

                // Checkmark — only visible when done
                if task.status == .done {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
        }
        .buttonStyle(.plain)  // Removes default Button tap highlight
    }

    // MARK: - Swipe Background

    // This appears BEHIND the white card as you drag it.
    // Green on the left (revealed when swiping right).
    // Amber on the right (revealed when swiping left).

    private var swipeBackground: some View {
        HStack(spacing: 0) {

            // Complete side (left, revealed on right-swipe)
            ZStack {
                AppTheme.Colors.success
                    .opacity(dragOffset > 20 ? 1 : 0)
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .padding(.leading, AppTheme.Spacing.xl)
                    .opacity(dragOffset > 40 ? 1 : 0)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Defer side (right, revealed on left-swipe)
            ZStack {
                AppTheme.Colors.warning
                    .opacity(dragOffset < -20 ? 1 : 0)
                Image(systemName: "clock.arrow.circlepath")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .padding(.trailing, AppTheme.Spacing.xl)
                    .opacity(dragOffset < -40 ? 1 : 0)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }

    // MARK: - Swipe Gesture

    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .local)
            .onChanged { value in
                // Only allow horizontal drag
                // Slight resistance: multiply by 0.75 so it feels weighted
                dragOffset = value.translation.width * 0.75
            }
            .onEnded { value in
                let threshold: CGFloat = 90  // How far to drag to trigger

                if value.translation.width > threshold {
                    // Dragged right far enough → complete
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        dragOffset = 500  // Fly off screen to the right
                    }
                    // Small delay so the fly-off animation plays first
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        onComplete()
                    }

                } else if value.translation.width < -threshold {
                    // Dragged left far enough → defer
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        dragOffset = -500  // Fly off screen to the left
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        onDefer()
                    }

                } else {
                    // Not dragged far enough → snap back to center
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                        dragOffset = 0
                    }
                }
            }
    }
}

// MARK: - Preview

#Preview("Active task") {
    let container = PersistenceController.preview.container
    let task = TaskItem(
        title: "Outline Q3 product narrative",
        status: .inbox,
        isInTodayFocus: true,
        estimatedMinutes: 60
    )
    container.mainContext.insert(task)

    return FocusCardView(
        task: task,
        index: 1,
        onComplete: { print("Complete tapped") },
        onDefer: { print("Defer tapped") }
    )
    .modelContainer(container)
    .padding()
    .background(AppTheme.Colors.background)
}

