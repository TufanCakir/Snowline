//
//  SnowlineFavorite.swift
//  Snowline
//
//  Created by Tufan Cakir on 24.12.25.
//

import Foundation

struct SnowlineFavorite: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let url: URL
    let created: Date
    let colorHex: String?
}

