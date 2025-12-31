//
//  SearchMode.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

enum SearchMode: String, CaseIterable {
    case all = "All"
    case ai = "AI"
    case music = "Music"
    case images = "Images"
    case maps = "Maps"

    var icon: String {
        switch self {
        case .all: return "sparkles"
        case .ai: return "brain"
        case .music: return "music.note"
        case .images: return "photo"
        case .maps: return "map"
        }
    }
}
