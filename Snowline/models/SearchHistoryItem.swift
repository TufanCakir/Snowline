//
//  SearchHistoryItem.swift
//  Snowline
//
//  Created by Tufan Cakir on 22.12.25.
//

import Foundation

struct SearchHistoryItem: Identifiable, Codable {
    let id: UUID
    let title: String
    let query: String
    let date: Date

    private enum CodingKeys: String, CodingKey {
        case id, title, query, date
    }

    init(id: UUID = UUID(), title: String, query: String, date: Date) {
        self.id = id
        self.title = title
        self.query = query
        self.date = date
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id =
            try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.title = try container.decode(String.self, forKey: .title)
        self.query = try container.decode(String.self, forKey: .query)
        self.date = try container.decode(Date.self, forKey: .date)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(query, forKey: .query)
        try container.encode(date, forKey: .date)
    }
}
