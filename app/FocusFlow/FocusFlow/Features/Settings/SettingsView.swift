//
//  SettingsView.swift
//  FocusFlow
//
//  Created by Ayça Kaycalı on 16.05.2026.
//

import SwiftUI

enum AppAppearance: String, CaseIterable, Identifiable {
    case system, light, dark
    var id: String { rawValue }

    var label: String {
        switch self {
        case .system: return "System"
        case .light:  return "Light"
        case .dark:   return "Dark"
        }
    }

    /// nil = follow the system; otherwise force light/dark.
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }
}
enum AppLanguage: String, CaseIterable, Identifiable {
    case system, en, tr
    var id: String { rawValue }

    var label: String {
        switch self {
        case .system: return "System"
        case .en:     return "English"
        case .tr:     return "Türkçe"
        }
    }

    /// nil = follow the device language; otherwise force this locale.
    var locale: Locale? {
        switch self {
        case .system: return nil
        case .en:     return Locale(identifier: "en")
        case .tr:     return Locale(identifier: "tr")
        }
    }
}

struct SettingsView: View {
    @AppStorage("appearance") private var appearance: AppAppearance = .system
    @AppStorage("appLanguage") private var language: AppLanguage = .system

    var body: some View {
        NavigationStack {
            List {
                Section("Appearance") {
                    Picker("Theme", selection: $appearance) {
                        ForEach(AppAppearance.allCases) { option in
                            Text(option.label).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Language") {
                    Picker("Language", selection: $language) {
                        ForEach(AppLanguage.allCases) { option in
                            Text(option.label).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppTheme.Colors.background)
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
