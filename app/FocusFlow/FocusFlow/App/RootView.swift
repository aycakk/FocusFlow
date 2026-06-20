import SwiftUI

struct RootView: View {
    
    @AppStorage("appearance") private var appearance: AppAppearance = .system
    @AppStorage("appLanguage") private var language: AppLanguage = .system
    
    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "scope")
                }

            TasksView()
                .tabItem {
                    Label("Tasks", systemImage: "list.bullet")
                }

            GoalsView()
                .tabItem {
                    Label("Goals", systemImage: "target")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
            
        }
        .tint(AppTheme.Colors.accent)
        .preferredColorScheme(appearance.colorScheme)
        .environment(\.locale, language.locale ?? .current)
    }
}

#Preview {
    RootView()
}
