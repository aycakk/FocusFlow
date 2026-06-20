//
//  OnboardingView.swift
//  FocusFlow
//
//  Created by Ayça Kaycalı on 19.05.2026.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: AppTheme.Spacing.xxl) {

                Spacer()

                VStack(spacing: AppTheme.Spacing.lg) {

                    Image(systemName: "scope")
                        .font(.system(size: 44))
                        .foregroundStyle(AppTheme.Colors.accent)

                    VStack(spacing: AppTheme.Spacing.sm) {

                        Text("One goal.\nOne day at a time.")
                            .font(.largeTitle.weight(.semibold))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(AppTheme.Colors.primaryText)

                        Text("FocusFlow turns big goals into calm daily focus.")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(AppTheme.Colors.secondaryText)
                    }
                }

                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {

                    FeatureRow(text: "Calm AI planning")

                    FeatureRow(text: "A focused day, not a backlog")

                    FeatureRow(text: "Works fully offline")
                }
                .padding(.horizontal, AppTheme.Spacing.xxl)

                Spacer()

                NavigationLink {
                    GoalCreationView(onFinished: {})
                } label: {
                    Text("Start Planning")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.lg)
                        .background(AppTheme.Colors.accent)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: AppTheme.Radius.lg,
                                style: .continuous
                            )
                        )
                }
                .padding(.horizontal, AppTheme.Spacing.xxl)

            }
            .padding(.bottom, AppTheme.Spacing.xxxl)
            .background(AppTheme.Colors.background)
        }
    }
}

private struct FeatureRow: View {

    let text: String

    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {

            Circle()
                .fill(AppTheme.Colors.accentSoft)
                .frame(width: 10, height: 10)

            Text(text)
                .font(.subheadline)
                .foregroundStyle(AppTheme.Colors.secondaryText)

            Spacer()
        }
    }
}


#Preview {
    OnboardingView()
}
