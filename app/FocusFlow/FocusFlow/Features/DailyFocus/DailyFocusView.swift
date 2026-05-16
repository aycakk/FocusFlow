//
//  DailyFocusView.swift
//  FocusFlow
//
//  Created by Ayça Kaycalı on 16.05.2026.
//

import SwiftUI

struct DailyFocusView: View {
    var body: some View {
        ZStack {
            AppTheme.Colors.background
                .ignoresSafeArea()
            
            VStack (alignment:.leading,spacing: AppTheme.Spacing.md ){
                Text("Daily Focus")
                    .font(.largeTitle.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.primaryText)
                
                Text("Today’s top focus tasks will appear here.")
                    .font(.body)
                    .foregroundStyle(AppTheme.Colors.secondaryText)
            }
            .padding(AppTheme.Spacing.xxl)
        }
    }
}
#Preview {
    DailyFocusView()
}
