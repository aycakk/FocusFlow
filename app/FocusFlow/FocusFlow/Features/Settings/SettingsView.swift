//
//  SettingsView.swift
//  FocusFlow
//
//  Created by Ayça Kaycalı on 16.05.2026.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    Text("Settings")
                        .font(.largeTitle.weight(.semibold))
                        .foregroundStyle(AppTheme.Colors.primaryText)

                    Text("App preferences and local AI settings will appear here.")
                        .font(.body)
                        .foregroundStyle(AppTheme.Colors.secondaryText)
                }
                .padding(AppTheme.Spacing.xxl)
            }
        }
}

#Preview {
    SettingsView()
}
