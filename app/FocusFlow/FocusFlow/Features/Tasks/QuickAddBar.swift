import SwiftUI

struct QuickAddBar: View {
    @Binding var text: String
    let onSubmit: () -> Void

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            // + icon button — tapping focuses the field
            Button {
                isFocused = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: AppTheme.Radius.sm, style: .continuous)
                        .fill(AppTheme.Colors.accentSoft)
                        .frame(width: 32, height: 32)
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(AppTheme.Colors.accent)
                }
            }
            .buttonStyle(.plain)

            // Text field
            TextField("Add a task", text: $text)
                .font(AppTheme.Typography.body)
                .foregroundStyle(AppTheme.Colors.primaryText)
                .focused($isFocused)
                .onSubmit {
                    onSubmit()
                    text = ""
                }

            // Submit button — appears only when there's something to add
            if !text.trimmingCharacters(in: .whitespaces).isEmpty {
                Button {
                    onSubmit()
                    text = ""
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 26))
                        .foregroundStyle(AppTheme.Colors.accent)
                }
                .buttonStyle(.plain)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.vertical, AppTheme.Spacing.md)
        .background(
            AppTheme.Colors.cardBackground
                .shadow(.drop(color: .black.opacity(0.04), radius: 2, x: 0, y: -1))
        )
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundStyle(AppTheme.Colors.border),
            alignment: .top
        )
    }
}

#Preview {
    QuickAddBar(text: .constant(""), onSubmit: {})
        .background(AppTheme.Colors.background)
}
