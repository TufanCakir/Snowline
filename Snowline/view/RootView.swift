//
//  RootView.swift
//  Slayken
//

import SwiftUI

struct RootView: View {
    var body: some View {

        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person")
                }
        }
    }
}
#Preview {
    RootView()
}
