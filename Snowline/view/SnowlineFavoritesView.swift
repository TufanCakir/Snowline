//
//  SnowlineFavoritesView.swift
//  Snowline
//
//  Created by Tufan Cakir on 24.12.25.
//

import SwiftUI

struct SnowlineFavoritesView: View {

    @EnvironmentObject private var favoritesStore: FavoritesStore

    @State private var editingFavorite: SnowlineFavorite?
    @State private var renameText = ""
    @State private var pickedColor: Color = .blue

    let onOpen: (URL) -> Void

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: 16) {

                ForEach(favoritesStore.favorites) { fav in
                    Button {
                        onOpen(fav.url)
                    } label: {
                        Text(fav.title)
                            .font(.footnote.weight(.medium))
                            .frame(maxWidth: .infinity, minHeight: 90)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color(hex: fav.colorHex ?? "#88CCFF").opacity(0.25))
                            )
                    }
                    .contextMenu {

                        Button("Bearbeiten") {
                            editingFavorite = fav
                            renameText = fav.title
                            pickedColor = Color(hex: fav.colorHex ?? "#88CCFF")
                        }

                        Divider()

                        Button(role: .destructive) {
                            favoritesStore.remove(fav)   // ✅ RICHTIG
                        } label: {
                            Label("Entfernen", systemImage: "trash")
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Favoriten")
        .sheet(item: $editingFavorite) { fav in
            editSheet(for: fav)
        }
    }

    // MARK: - Edit Sheet

    private func editSheet(for fav: SnowlineFavorite) -> some View {
        NavigationStack {
            VStack(spacing: 20) {

                TextField("Name", text: $renameText)
                    .textFieldStyle(.roundedBorder)

                ColorPicker("Farbe", selection: $pickedColor, supportsOpacity: false)

                Spacer()

                Button("Speichern") {
                    favoritesStore.update(
                        SnowlineFavorite(
                            id: fav.id,
                            title: renameText,
                            url: fav.url,
                            created: fav.created,
                            colorHex: pickedColor.toHex()
                        )
                    )
                    editingFavorite = nil
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("Favorit bearbeiten")
            .presentationDetents([.height(300)])
        }
    }
}
