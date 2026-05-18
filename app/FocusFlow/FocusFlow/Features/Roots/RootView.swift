//
//  RootView.swift
//  FocusFlow
//
//  Created by Ayça Kaycalı on 16.05.2026.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView{
            DailyFocusView()
                .tabItem{
                    Label("Focus",systemImage:"target")
                }
            SettingsView()
                .tabItem{
                    Label("Settings",systemImage:"gearshape")
                }
        }.tint(AppTheme.Colors.accent)
    }
}

#Preview {
    RootView()
}
