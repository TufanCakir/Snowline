//
//  IndexStore.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import Foundation

actor IndexStore {

    private let stopWords: Set<String> = [
        "the", "and", "or", "with", "to", "for", "a", "an", "of",
        "der", "die", "das", "und", "oder", "mit", "zu", "von", "im", "in",
    ]

    private var index: [String: Set<URL>] = [:]
    private var pages: [URL: String] = [:]
    private var popularity: [URL: Int] = [:]
    private var visited: Set<URL> = []

    func shouldVisit(_ url: URL) -> Bool {
        guard !visited.contains(url) else { return false }
        visited.insert(url)
        return true
    }

    func indexPage(_ url: URL, html: String) {
        pages[url] = html
        popularity[url, default: 0] += 1

        let tokens =
            html
            .lowercased()
            .components(separatedBy: .alphanumerics.inverted)
            .filter { $0.count > 2 && !stopWords.contains($0) }

        for w in tokens {
            index[w, default: []].insert(url)
        }
    }

    func urls(for token: String) -> Set<URL> {
        index[token] ?? []
    }

    func indexPage(url: URL, html: String) {
        let words =
            html
            .lowercased()
            .split(whereSeparator: { !$0.isLetter })
            .filter { $0.count > 2 }

        for w in words {
            index[String(w), default: []].insert(url)
        }
    }
}
