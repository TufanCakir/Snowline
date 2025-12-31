//
//  Crawler.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import Foundation

actor Crawler {

    static let shared = Crawler()

    private let semaphore = AsyncSemaphore(value: 4)

    func crawl(url: URL) async {

        guard await SearchCore.shared.isAllowed(url) else { return }
        guard await SearchCore.shared.shouldVisit(url) else { return }

        await semaphore.wait()
        await crawlBody(url: url)
        await semaphore.signal()
    }

    private func crawlBody(url: URL) async {

        var request = URLRequest(url: url)
        request.timeoutInterval = 12
        request.setValue("SnowlineBot/1.0", forHTTPHeaderField: "User-Agent")

        do {
            let (data, response) = try await URLSession.shared.data(
                for: request
            )
            guard let res = response as? HTTPURLResponse,
                (200...299).contains(res.statusCode)
            else { return }

            let html = String(decoding: data, as: UTF8.self)
            await SearchCore.shared.indexPage(url: url, html: html)

            for link in await html.extractLinks().prefix(8) {
                guard let next = URL(string: link),
                    await SearchCore.shared.isAllowed(next)
                else { continue }

                Task.detached(priority: .background) {
                    await Crawler.shared.crawl(url: next)
                }
            }
        } catch {
            // silently ignore dead links
        }
    }
}
