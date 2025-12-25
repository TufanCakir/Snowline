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

    @StateObject private var themeManager = ThemeManager()
    @StateObject private var internetMonitor = InternetMonitor()
    @StateObject private var favoritesStore = FavoritesStore()

    @AppStorage("hasSeenOnboarding")
    private var hasSeenOnboarding = false

    // MARK: - Scene

    var body: some Scene {
        WindowGroup {
            RootRouter()
                .environmentObject(themeManager)
                .environmentObject(internetMonitor)
                .environmentObject(favoritesStore)
                .preferredColorScheme(themeManager.colorScheme)
                .tint(themeManager.accentColor)
        }
    }
}

struct RootRouter: View {

    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some View {
        if hasSeenOnboarding {
            RootView()
        } else {
            OnboardingView {
                hasSeenOnboarding = true
            }
        }
    }
}
