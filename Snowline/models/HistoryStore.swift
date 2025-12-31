//
//  HistoryStore.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

internal import Combine
import Foundation
internal import UIKit
import WebKit

final class HistoryStore: ObservableObject {

    static let shared = HistoryStore()

    struct Entry: Identifiable, Codable {
        let id: UUID
        let url: String
        let title: String
        let date: Date
        var isFavorite: Bool
        var screenshot: Data?
    }

    @Published private(set) var entries: [Entry] = []

    private let key = "history"

    private init() { load() }

    func save(url: URL, title: String, screenshot: UIImage?) {
        let data = screenshot?.jpegData(compressionQuality: 0.7)

        let entry = Entry(
            id: UUID(),
            url: url.absoluteString,
            title: title,
            date: Date(),
            isFavorite: false,
            screenshot: data
        )

        entries.insert(entry, at: 0)
        persist()
    }

    func toggleFavorite(_ entry: Entry) {
        guard let i = entries.firstIndex(where: { $0.id == entry.id }) else {
            return
        }
        entries[i].isFavorite.toggle()
        persist()
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
            let saved = try? JSONDecoder().decode([Entry].self, from: data)
        else { return }
        entries = saved
    }
}
