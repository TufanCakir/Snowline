//
//  SearchCore.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

internal import Combine
import Foundation
internal import UIKit

@MainActor
final class SearchCore: ObservableObject {

    static let shared = SearchCore()
    private let store = IndexStore()
    private var cache: [URL: CleanPage] = [:]

    struct CleanPage {
        let title: String
        let text: String
    }

    // MARK: - Index

    func indexPage(url: URL, html: String) async {
        let clean = cleanHTML(html)
        let title = extractTitle(from: html, url: url)

        cache[url] = CleanPage(title: title, text: clean)
        await store.indexPage(url, html: clean)
    }

    func shouldVisit(_ url: URL) async -> Bool {
        await store.shouldVisit(url)
    }

    // MARK: - Allowlist

    func isAllowed(_ url: URL) -> Bool {
        guard let host = url.host else { return false }
        if host.contains(".wikipedia.org") && host != "en.wikipedia.org" {
            return false
        }

        return [
            "wikipedia.org", "apple.com", "developer.apple.com", "github.com",
            "news.ycombinator.com",
        ]
        .contains { host.contains($0) }
    }

    private func canonical(_ url: URL) -> URL {
        guard var c = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            return url
        }

        c.query = nil  // ?ref=abc
        c.fragment = nil  // #section

        return c.url ?? url
    }

    private func bestSnippet(from text: String, matching words: [String])
        -> String
    {
        let clean =
            text
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\t", with: " ")

        let maxLength = 200

        guard let hit = bestHitRange(in: clean, words: words) else {
            return String(clean.prefix(maxLength)).trimmingCharacters(
                in: CharacterSet.whitespaces
            ) + "…"
        }

        // Compute center safely without direct String.Index arithmetic
        let distance = clean.distance(from: hit.lowerBound, to: hit.upperBound)
        let half = distance / 2
        let center = clean.index(hit.lowerBound, offsetBy: half)

        let startCandidate =
            clean.index(
                center,
                offsetBy: -maxLength / 2,
                limitedBy: clean.startIndex
            ) ?? clean.startIndex
        let start = max(clean.startIndex, startCandidate)
        let end =
            clean.index(start, offsetBy: maxLength, limitedBy: clean.endIndex)
            ?? clean.endIndex

        var snippet = String(clean[start..<end])

        if start != clean.startIndex { snippet = "… " + snippet }
        if end != clean.endIndex { snippet += " …" }

        return snippet.trimmingCharacters(in: CharacterSet.whitespaces)
    }

    private func bestHitRange(in text: String, words: [String]) -> Range<
        String.Index
    >? {
        let lower = text.lowercased()
        var best: (range: Range<String.Index>, score: Int)?

        for w in words {
            guard w.count > 2 else { continue }

            var pos = lower.startIndex
            while let r = lower.range(of: w, range: pos..<lower.endIndex) {
                let localStart =
                    text.index(
                        r.lowerBound,
                        offsetBy: -40,
                        limitedBy: text.startIndex
                    ) ?? text.startIndex
                let localEnd =
                    text.index(
                        r.upperBound,
                        offsetBy: 40,
                        limitedBy: text.endIndex
                    ) ?? text.endIndex
                let area = lower[localStart..<localEnd]

                let score = words.filter { area.contains($0) }.count
                if best == nil || score > best!.score {
                    best = (localStart..<localEnd, score)
                }

                pos = r.upperBound
            }
        }

        return best?.range
    }

    private func cleanHTML(_ html: String) -> String {

        var t = html

        // Remove scripts, styles, head, nav, footer
        t = t.replacingOccurrences(
            of: "<script[\\s\\S]*?</script>",
            with: " ",
            options: .regularExpression
        )
        t = t.replacingOccurrences(
            of: "<style[\\s\\S]*?</style>",
            with: " ",
            options: .regularExpression
        )
        t = t.replacingOccurrences(
            of: "<head[\\s\\S]*?</head>",
            with: " ",
            options: .regularExpression
        )
        t = t.replacingOccurrences(
            of: "<nav[\\s\\S]*?</nav>",
            with: " ",
            options: .regularExpression
        )
        t = t.replacingOccurrences(
            of: "<footer[\\s\\S]*?</footer>",
            with: " ",
            options: .regularExpression
        )

        // Remove all tags
        t = t.replacingOccurrences(
            of: "<[^>]+>",
            with: " ",
            options: .regularExpression
        )

        // Decode HTML entities
        t = decodeHTMLEntities(t)

        // Kill SEO spam phrases
        let spam = [
            "mac ipad iphone watch vision airpods tv home",
            "apple apple apple",
            "support 0",
            "learn more",
            "click here",
            "download",
            "platform",
            "app store",
            "privacy policy",
            "terms of use",
        ]

        for s in spam {
            t = t.replacingOccurrences(
                of: s,
                with: " ",
                options: [.caseInsensitive]
            )
        }

        // Normalize whitespace
        t = t.replacingOccurrences(
            of: "\\s+",
            with: " ",
            options: .regularExpression
        )

        return t.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func decodeHTMLEntities(_ text: String) -> String {
        guard let data = text.data(using: .utf8) else { return text }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue,
        ]

        if let decoded = try? NSAttributedString(
            data: data,
            options: options,
            documentAttributes: nil
        ) {
            return decoded.string
        }
        return text
    }

    private func extractTitle(from html: String, url: URL) -> String {
        if let r = html.range(
            of: "<title>(.*?)</title>",
            options: .regularExpression
        ) {
            let t = html[r].replacingOccurrences(
                of: "<[^>]+>",
                with: "",
                options: .regularExpression
            )
            if t.count > 4 { return t }
        }
        return url.host ?? "Website"
    }

    private func tokenize(_ text: String) -> [String] {
        text.lowercased().split(whereSeparator: { !$0.isLetter }).map(
            String.init
        )
    }

    private func relevanceScore(
        _ words: [String],
        _ text: String,
        title: String
    ) -> Int {
        var score = 0

        for w in words {
            if title.lowercased().contains(w) { score += 6 }
            if text.lowercased().contains(w) { score += 3 }
        }

        return score
    }

    // MARK: - Query Engine
    private func search(_ query: String) async -> [URL] {
        let words = tokenize(query)
        guard !words.isEmpty else { return [] }

        // Score cached pages by simple term presence
        let scored: [(url: URL, score: Int)] = cache.map { (url, page) in
            var s = 0
            let titleLower = page.title.lowercased()
            let textLower = page.text.lowercased()
            for w in words {
                if titleLower.contains(w) { s += 6 }
                if textLower.contains(w) { s += 3 }
            }
            return (url, s)
        }
        .filter { $0.score > 0 }
        .sorted { lhs, rhs in
            if lhs.score == rhs.score {
                return lhs.url.absoluteString < rhs.url.absoluteString
            }
            return lhs.score > rhs.score
        }

        return scored.map { $0.url }
    }

    // MARK: - Search
    func searchResults(for query: String) async -> [Result] {

        let urls = await search(query)
        var used = Set<URL>()
        var out: [Result] = []

        let words = tokenize(query)

        for url in urls {
            let canon = canonical(url)
            guard let page = cache[url], !used.contains(canon) else { continue }
            used.insert(canon)

            let score = relevanceScore(words, page.text, title: page.title)
            guard score > 0 else { continue }

            let snippet = bestSnippet(from: page.text, matching: words)

            out.append(
                Result(
                    url: url,
                    title: page.title,
                    snippet: snippet,
                    score: score
                )
            )
        }

        return Array(out.prefix(12))
    }

}

extension String {
    func extractLinks() -> [String] {
        let pattern = #"href\s*=\s*["'](https?://[^"']+)["']"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return []
        }

        let ns = self as NSString
        let results = regex.matches(
            in: self,
            range: NSRange(location: 0, length: ns.length)
        )
        return results.compactMap { ns.substring(with: $0.range(at: 1)) }
    }
}
