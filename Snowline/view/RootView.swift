//
//  RootView.swift
//  Slayken
//

import SwiftUI

struct RootView: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

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
            .padding()

            RoundedRectangle(cornerRadius: 0)
                .strokeBorder(Color.clear)
                .animatedRainbowBorder(active: true)
        }
    }
}
#Preview {
    RootView()
}
