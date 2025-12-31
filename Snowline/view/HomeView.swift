//
//  HomeView.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import SwiftUI

struct HomeView: View {

    @State private var query = ""
    @State private var results: [Result] = []
    @State private var cache: [String: [Result]] = [:]
    @State private var lastQuery = ""
    @State private var showImageSearch = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    VStack(spacing: 16) {
                        ForEach(results) { result in
                            ResultCard(result: result)
                        }
                    }

                    HStack {
                        ActionChip(icon: "sparkles", title: "KI-Modus")
                        ActionChip(icon: "music.note", title: "Musik")
                        ActionChip(icon: "photo", title: "Bilder") {
                            showImageSearch = true
                        }
                    }

                    HStack {
                        Card(title: "Hameln", value: "0°", icon: "moon")
                        Card(title: "Sunrise", value: "8:32", icon: "sunrise")
                    }
                }
                .padding(.bottom, 120)
            }
        }
        .navigationTitle("Snowline")
        .searchable(
            text: $query,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search the web"
        )
        .onChange(of: query) { runSearch($1) }
        .sheet(isPresented: $showImageSearch) { ImageSearchView() }
    }

    // MARK: Native Engine

    private func runSearch(_ text: String) {
        let clean =
            text
            .lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .joined(separator: " ")
            .trimmingCharacters(in: .whitespaces)

        guard clean.count > 1 else {
            results = []
            lastQuery = ""
            return
        }

        if clean == lastQuery { return }

        if let cached = cache[clean] {
            results = cached
            lastQuery = clean
            return
        }

        Task {
            let found = await SearchCore.shared.searchResults(for: clean)
            cache[clean] = found
            lastQuery = clean
            results = found
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(SnowlineThemeManager.shared)
}
