//
//  SnowlineView.swift
//  Snowline
//
//  Created by Tufan Cakir on 22.12.25.
//

import SwiftUI
import WebKit

struct SnowlineView: View {

    @EnvironmentObject private var themeManager: ThemeManager
    @AppStorage("snowline_startpage") private var selectedStartPage: StartPage =
        .google
    @AppStorage("snowline_pending_search") private var pendingSearch: String =
        ""
    @FocusState private var searchFocused: Bool

    @State private var searchText = ""
    @State private var currentURL: URL?
    @State private var showStartPageSheet = false
    @State private var isSnowlineActive = true
    @State private var selectedIntent: SearchIntent = .search

    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.backgroundColor
                    .ignoresSafeArea()
                    .onTapGesture { searchFocused = false }

                if currentURL == nil {
                    SnowlineStartView(
                        engine: selectedStartPage,
                        searchText: $searchText,
                        onSubmit: performSearch,
                        searchFocused: $searchFocused,
                        selectedIntent: $selectedIntent
                    )

                } else {
                    WebView(url: currentURL!)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        currentURL = nil
                    } label: {
                        Image(systemName: "house")
                            .foregroundStyle(themeManager.toolbarIconColor)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        AccountView()
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .foregroundStyle(themeManager.toolbarIconColor)
                    }
                }
            }
        }
        .onAppear { handlePendingSearch() }
    }

    // MARK: - Search Logic
    private func performSearch() {
        guard !searchText.isEmpty else { return }

        let finalQuery =
            searchText + selectedIntent.querySuffix

        currentURL =
            selectedStartPage.searchURL(for: finalQuery)

        searchText = ""
    }

    // MARK: - Siri / Shortcut Search
    private func handlePendingSearch() {
        guard !pendingSearch.isEmpty else { return }
        currentURL = selectedStartPage.searchURL(for: pendingSearch)
        pendingSearch = ""
    }
}

#Preview {
    SnowlineView()
        .environmentObject(ThemeManager())
}
