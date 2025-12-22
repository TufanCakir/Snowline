//
//  SnowlineSearchIntent.swift
//  Snowline
//
//  Created by Tufan Cakir on 22.12.25.
//

import AppIntents

struct SearchInSnowlineIntent: AppIntent {

    static var title: LocalizedStringResource = "Search in Snowline"
    static var description =
        IntentDescription("Search the web using Snowline")

    static var openAppWhenRun = true

    @Parameter(title: "Search Query")
    var query: String

    func perform() async throws -> some IntentResult {
        UserDefaults.standard.set(
            query,
            forKey: "snowline_pending_search"
        )
        return .result()
    }
}
