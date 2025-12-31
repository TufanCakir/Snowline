//
//  FavoritesView.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import SwiftUI

struct FavoritesView: View {

    @ObservedObject private var store = HistoryStore.shared
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.entries.filter { $0.isFavorite }) { entry in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(entry.title)
                            Text(entry.url)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "star.fill").foregroundStyle(.yellow)
                    }
                }
            }
            .navigationTitle("Favorites")
            .toolbar {
                Button("Close") { dismiss() }
            }
        }
    }
}
