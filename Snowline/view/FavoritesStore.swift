//
//  FavoritesStore.swift
//  Snowline
//
//  Created by Tufan Cakir on 24.12.25.
//

import SwiftUI
internal import Combine

@MainActor
final class FavoritesStore: ObservableObject {

    @AppStorage("snowline_favorites")
    private var data: Data = Data()

    @Published private(set) var favorites: [SnowlineFavorite] = []

    init() {
        load()
    }

    private func load() {
        favorites = (try? JSONDecoder().decode([SnowlineFavorite].self, from: data)) ?? []
    }

    private func persist() {
        data = (try? JSONEncoder().encode(favorites)) ?? Data()
    }

    // MARK: - Actions

    func add(_ fav: SnowlineFavorite) {
        guard !favorites.contains(where: {$0.id == fav.id}) else { return }
        favorites.insert(fav, at: 0)
        persist()
    }

    func remove(_ fav: SnowlineFavorite) {
        favorites.removeAll { $0.id == fav.id }
        persist()
    }

    func update(_ fav: SnowlineFavorite) {
        if let i = favorites.firstIndex(where: {$0.id == fav.id}) {
            favorites[i] = fav
            persist()
        }
    }
}
