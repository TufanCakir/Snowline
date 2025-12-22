//
//  SnowlineApp.swift
//  Snowline
//
//  Created by Tufan Cakir on 22.12.25.
//

import SwiftUI

@main
struct SnowlineApp: App {

    // MARK: - Global State
    @StateObject private var themeManager: ThemeManager
    @StateObject private var internet: InternetMonitor

    @AppStorage("hasSeenOnboarding")
    private var hasSeenOnboarding = false

    // MARK: - Init
    init() {
        _themeManager = StateObject(wrappedValue: ThemeManager())
        _internet = StateObject(wrappedValue: InternetMonitor())
    }

    // MARK: - Scene
    var body: some Scene {
        WindowGroup {
            Group {
                if hasSeenOnboarding {
                    RootView()
                } else {
                    OnboardingView {
                        hasSeenOnboarding = true
                    }
                }
            }
            // ✅ ENV FÜR ALLE
            .environmentObject(themeManager)
            .environmentObject(internet)

            // ✅ THEME GLOBAL
            .preferredColorScheme(themeManager.colorScheme)
            .tint(themeManager.accentColor)
        }
    }
}
