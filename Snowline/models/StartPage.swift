//
//  StartPage.swift
//  Snowline
//
//  Created by Tufan Cakir on 22.12.25.
//

import Foundation

enum StartPage: String, CaseIterable, Identifiable {

    case google

    // MARK: - Identifiable
    var id: String { rawValue }

    // MARK: - Display Title
    var title: String {
        switch self {
        case .google: return "Google"
        }
    }

  

    // MARK: - Home URL
    var url: URL {
        switch self {
        case .google:
            return URL(string: "https://www.google.com")!
        }
    }

    // MARK: - Search URL
    func searchURL(for query: String) -> URL {
        let encoded =
        query
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        ?? ""
        
        switch self {
        case .google:
            return URL(string: "https://www.google.com/search?q=\(encoded)")!
}
    }
}
