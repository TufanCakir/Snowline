//
//  Seed.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import Foundation

struct Seed: Codable, Identifiable, Hashable {
    let id: String
    let url: URL
    let domain: String
    let category: SeedCategory
    let priority: Int
    let maxDepth: Int
    let recrawlHours: Int

    var lastCrawled: Date?
    var discovered: Date = Date()

    init(
        url: URL,
        category: SeedCategory,
        priority: Int,
        maxDepth: Int,
        recrawlHours: Int
    ) {
        self.url = url
        self.domain = url.host ?? ""
        self.category = category
        self.priority = priority
        self.maxDepth = maxDepth
        self.recrawlHours = recrawlHours

        // Canonical ID = domain + path
        self.id = "\(domain)\(url.path)"
    }
}

enum SeedCategory: String, Codable {
    case news
    case dev
    case wiki
    case trending
    case blogs
}
