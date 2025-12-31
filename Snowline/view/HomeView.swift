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

    @State private var debounceTask: Task<Void, Never>?
    @State private var pending = false

    // Damit alte Tasks nicht später “reinfunken”
    @State private var searchToken = UUID()
    @State private var mode: SearchMode = .all
    @State private var selectedCode: String? = nil

    private var currentTimeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // Main scrollable content
                ScrollView {
                    VStack(spacing: 16) {
                        SearchBar(text: $query, onSubmit: performSearch)

                        // Results list
                        VStack(spacing: 16) {
                            ForEach(results, id: \.url) { result in
                                ResultCard(result: result)
                                    .transition(
                                        .opacity.combined(
                                            with: .move(edge: .top)
                                        )
                                    )
                            }
                        }

                        // Quick actions
                        Picker("Mode", selection: $mode) {
                            chip(.all, "sparkles").tag(SearchMode.all)

                            chip(.ai, "brain").tag(SearchMode.ai)
                            chip(.music, "music.note").tag(SearchMode.music)
                            chip(.images, "photo").tag(SearchMode.images)
                            chip(.maps, "map").tag(SearchMode.maps)
                        }
                        .pickerStyle(.segmented)

                        // Cards row and clock
                        HStack(spacing: 30) {
                            Card(title: "Hameln", value: "0°", icon: "moon")
                            Card(
                                title: "Sunrise",
                                value: "8:32",
                                icon: "sunrise"
                            )
                        }
                        DateView()

                    }
                    HStack {
                        NavigationLink {
                            MapView()
                        } label: {
                            Text("Map").font(.title)
                        }
                        .padding()
                        .frame(width: 200)
                        .background(
                            .ultraThinMaterial,
                            in: RoundedRectangle(cornerRadius: 50)
                        )
                        NavigationLink {
                            ImageSearchView()
                        } label: {
                            Text("Gallery").font(.title)
                        }
                        .padding()
                        .frame(width: 200)
                        .background(
                            .ultraThinMaterial,
                            in: RoundedRectangle(cornerRadius: 50)
                        )
                    }
                }

                VStack(spacing: 8) {
                    FloatingAddressBar(query: $query)
                }

                // Bottom bar anchored at bottom
                BottomBar()
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .overlay(alignment: .top) {
            if pending {
                ProgressView()
                    .scaleEffect(0.7)
                    .opacity(0.4)
                    .padding(.top, 6)
            }
        }
    }

    private func chip(_ modeValue: SearchMode, _ icon: String) -> some View {
        ActionChip(
            icon: icon,
            title: modeValue.rawValue,
            isSelected: mode == modeValue
        ) {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                mode = modeValue
            }
        }
    }

    // MARK: - Search
    @MainActor
    private func runSearch(_ clean: String, token: UUID) async {
        if clean == lastQuery {
            pending = false
            return
        }

        if let cached = cache[clean] {
            lastQuery = clean
            pending = false
            withAnimation(.easeOut(duration: 0.25)) {
                results = cached
            }
            prefetchPrediction(from: clean)  // optional
            return
        }

        let foundRaw = await SearchCore.shared.searchResults(for: clean)

        // Dublikate raus
        let found = dedupe(foundRaw)

        // Wenn sich der Token geändert hat, Results NICHT setzen
        guard token == searchToken else { return }

        cache[clean] = found
        lastQuery = clean
        pending = false

        withAnimation(.easeOut(duration: 0.25)) {
            results = found
        }

        prefetchPrediction(from: clean)
    }

    private func performSearch() {
        let clean = normalize(query)
        guard clean.count > 1 else {
            pending = false
            results = []
            lastQuery = ""
            return
        }

        let token = UUID()
        searchToken = token
        pending = true

        Task { @MainActor in
            await runSearch(clean, token: token)
        }
    }

    // MARK: - Helpers
    private func normalize(_ text: String) -> String {
        text
            .lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .joined(separator: " ")
            .trimmingCharacters(in: .whitespaces)
    }

    private func dedupe(_ input: [Result]) -> [Result] {
        var seen = Set<String>()
        var out: [Result] = []
        out.reserveCapacity(input.count)

        for r in input {
            var comps = URLComponents(
                url: r.url,
                resolvingAgainstBaseURL: false
            )
            comps?.query = nil
            comps?.fragment = nil

            let normalized = (comps?.url ?? r.url).absoluteString.lowercased()

            if seen.insert(normalized).inserted {
                out.append(r)
            }
        }

        return out
    }

    private func prefetchPrediction(from clean: String) {
        // “Google Magic”: minimaler Prefetch (optional)
        Task.detached {
            let words = clean.split(separator: " ").map(String.init)
            guard let last = words.last, last.count >= 3 else { return }

            let predicted =
                (words.dropLast().joined(separator: " ") + " " + last.prefix(3))
                .trimmingCharacters(in: .whitespaces)

            _ = await SearchCore.shared.searchResults(for: predicted)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(SnowlineThemeManager.shared)
}
