//
//  SearchIntent.swift
//  Snowline
//
//  Created by Tufan Cakir on 22.12.25.
//

import Foundation

enum SearchIntent: String, CaseIterable, Identifiable {
    case search
    case learn
    case howto
    case docs
    case compare
    case buy
    case videos
    case explain

    // Identifiable conformance
    var id: String { rawValue }

    var title: String {
        switch self {
        case .search: return "Search"
        case .learn: return "Learn"
        case .buy: return "Buy"
        case .explain: return "Explain"
        case .compare: return "Compare"
        case .howto: return "How To"
        case .docs: return "Docs"
        case .videos: return "Videos"
        }
    }

    var icon: String {
        switch self {
        case .search: return "magnifyingglass"
        case .learn: return "graduationcap"
        case .buy: return "cart"
        case .explain: return "brain"
        case .compare: return "rectangle.2.swap"
        case .howto: return "questionmark.circle"
        case .docs: return "doc.text"
        case .videos: return "play.rectangle"
        }
    }

    /// 👇 beeinflusst die Suche
    var querySuffix: String {
        switch self {
        case .search: return ""
        case .learn: return " tutorial"
        case .buy: return " review"
        case .explain: return " explained"
        case .compare: return " vs"
        case .howto: return " how to"
        case .docs: return " documentation"
        case .videos: return " video"
        }
    }
}
