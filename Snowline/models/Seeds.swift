//
//  Seeds.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import Foundation

let Seeds: [Seed] = [
    Seed(
        url: URL(string: "https://en.wikipedia.org")!,
        category: .wiki,
        priority: 10,
        maxDepth: 3,
        recrawlHours: 24
    ),
    Seed(
        url: URL(string: "https://developer.apple.com")!,
        category: .dev,
        priority: 10,
        maxDepth: 2,
        recrawlHours: 24
    ),
    Seed(
        url: URL(string: "https://news.ycombinator.com")!,
        category: .news,
        priority: 9,
        maxDepth: 2,
        recrawlHours: 1
    ),
    Seed(
        url: URL(string: "https://github.com")!,
        category: .dev,
        priority: 8,
        maxDepth: 2,
        recrawlHours: 12
    ),
    Seed(
        url: URL(string: "https://www.apple.com")!,
        category: .trending,
        priority: 7,
        maxDepth: 1,
        recrawlHours: 24
    ),
]
