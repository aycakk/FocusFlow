//
//  FocusFlowApp.swift
//  FocusFlow
//
//  Created by Ayça Kaycalı on 15.05.2026.
//

import SwiftUI
import SwiftData
@main
struct FocusFlowApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .modelContainer(PersistenceController.shared.container)
        }
    }
}
