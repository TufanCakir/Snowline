//
//  StartPage.swift
//  Snowline
//
//  Created by Tufan Cakir on 22.12.25.
//

import Foundation

enum StartPage: String, CaseIterable, Identifiable {

    case google

    var id: String { rawValue }

    var title: String {
        "Google"
    }

    /// Home page
    var homeURL: URL {
        URL(string: "https://www.google.com")!
    }

    /// Search
    func searchURL(for query: String) -> URL {
        let encoded = query
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        return URL(string: "https://www.google.com/search?q=\(encoded)")!
    }
}
