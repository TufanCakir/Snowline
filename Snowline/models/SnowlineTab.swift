//
//  SnowlineTab.swift
//  Snowline
//
//  Created by Tufan Cakir on 23.12.25.
//

import Foundation

enum BrowsingMode: String, Codable {
    case normal
    case `private`
}

struct SnowlineTab: Identifiable, Codable {
    let id: UUID
    var url: URL?
    var title: String
    var mode: BrowsingMode

    init(
        id: UUID = UUID(),
        url: URL? = nil,
        title: String = "New Tab",
        mode: BrowsingMode = .normal
    ) {
        self.id = id
        self.url = url
        self.title = title
        self.mode = mode
    }

    // Codable conformance is synthesized correctly with these stored properties,
    // but we provide CodingKeys explicitly for clarity and stability.
    private enum CodingKeys: String, CodingKey {
        case id
        case url
        case title
        case mode
    }
}

extension SnowlineTab {
    static func normal() -> SnowlineTab {
        SnowlineTab(mode: .normal)
    }

    static func `private`() -> SnowlineTab {
        SnowlineTab(mode: .private)
    }
}

extension SnowlineTab {
    var isPrivate: Bool {
        mode == .private
    }
}
