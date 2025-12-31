//
//  BottomBar.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import SwiftUI

struct BottomBar: View {

    @ObservedObject var ui = BrowserUI.shared
    @State private var showHistory = false
    @State private var showFavorites = false
    @State private var showImageSearch = false
    @State private var showSettings = false
    @State private var showTabs: Bool = false

    var body: some View {
        HStack(spacing: 14) {
            Menu {
                Button(action: { showTabs = true }) {
                    dockButton("plus", "New Tab") {}
                }

                Button(action: { showHistory = true }) {
                    dockButton("clock", "History") {}
                }

                Button(action: { showFavorites = true }) {
                    dockButton("star", "Favorites") {}
                }

                Button(action: { ui.showTabs.toggle() }) {
                    dockButton("square.on.square", "Tabs") {}
                }

                Button(action: { showImageSearch = true }) {
                    dockButton("photo", "Image") {}
                }

                Button(action: { ui.privateMode.toggle() }) {
                    dockButton(ui.privateMode ? "eye.slash" : "eye", "Private")
                    {}
                }

                Button(action: { showSettings = true }) {
                    dockButton("gear", "Settings") {}
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 36, height: 36)
            }
            .padding(14)
            .background(.ultraThinMaterial, in: Capsule())
            .shadow(radius: 18, y: 8)
            .padding(.bottom, 22)
            .sheet(isPresented: $showHistory) { HistoryView() }
            .sheet(isPresented: $showFavorites) { FavoritesView() }
            .sheet(isPresented: $showImageSearch) {
                NavigationStack { ImageSearchView() }
            }
            .sheet(isPresented: $showSettings) { AccountView() }
        }
    }
    private func dockButton(
        _ icon: String,
        _ title: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .frame(width: 36, height: 36)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }
}
