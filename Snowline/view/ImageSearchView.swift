//
//  ImageSearchView.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import PhotosUI
import SwiftUI

struct ImageSearchView: View {

    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var isSearching = false

    var body: some View {
        VStack(spacing: 24) {

            Spacer()

            Group {
                if let image = selectedImage {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 260)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .shadow(radius: 12)
                } else {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                        .frame(height: 260)
                        .overlay {
                            Label("Select an image", systemImage: "photo")
                                .foregroundStyle(.secondary)
                        }
                }
            }

            PhotosPicker(selection: $selectedItem, matching: .images) {
                Label("Choose Photo", systemImage: "photo.on.rectangle")
            }
            .buttonStyle(.borderedProminent)

            Button {
                isSearching = true
                // ➜ Hook here: your Slayken image engine
            } label: {
                Label("Search by Image", systemImage: "sparkle.magnifyingglass")
            }
            .buttonStyle(.bordered)
            .disabled(selectedImage == nil)

            Spacer()
        }
        .padding()
        .navigationTitle("Image Search")
        .onChange(of: selectedItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(
                    type: Data.self
                ),
                    let uiImage = UIImage(data: data)
                {
                    selectedImage = Image(uiImage: uiImage)
                }
            }
        }
    }
}
