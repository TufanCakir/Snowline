import SwiftUI

@main
struct SnowlineApp: App {

    @StateObject private var theme = ThemeManager()

    @AppStorage("hasSeenOnboarding")
    private var hasSeenOnboarding = false

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
            .environmentObject(theme)
            .onAppear {
                Discovery.shared.start()
            }
        }
    }
}
