//
//  Discovery.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

final class Discovery {

    static let shared = Discovery()
    private var started = false

    func start() {
        guard !started else { return }
        started = true

        Task.detached(priority: .background) {
            while true {
                for seed in await Seeds {
                    Task.detached(priority: .background) {
                        await Crawler.shared.crawl(url: seed.url)
                    }
                }

                try? await Task.sleep(for: .seconds(60 * 60))
            }
        }
    }
}
