//
//  RootView.swift
//  Khione
//

import SwiftUI

struct RootView: View {

    @EnvironmentObject private var internet: InternetMonitor
    @State private var selectedTab: Tab = .browser

    var body: some View {
        Group {
            if internet.isConnected {
                TabView(selection: $selectedTab) {

                    // 🌐 Browser
                    NavigationStack {
                        SnowlineView()
                    }
                    .tabItem {
                        Label("Browse", systemImage: "globe")
                    }
                    .tag(Tab.browser)

                    // 👤 Account
                    NavigationStack {
                        AccountView()
                    }
                    .tabItem {
                        Label("Account", systemImage: "person.crop.circle")
                    }
                    .tag(Tab.account)
                }
            } else {
                NoInternetView()
            }
        }
        .animation(.easeInOut(duration: 0.25), value: internet.isConnected)
    }
}

// MARK: - Tabs
private enum Tab {
    case browser
    case account
}
