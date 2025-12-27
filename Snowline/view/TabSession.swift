//
//  TabSession.swift
//  Snowline
//
//  Created by Tufan Cakir on 27.12.25.
//

import Combine
import SwiftUI

final class TabSession: ObservableObject {

    @Published private(set) var tabs: [BrowserTab]
    @Published var selectedTabID: UUID

    init() {
        let first = BrowserTab()
        self.tabs = [first]
        self.selectedTabID = first.id
        // Try to load persisted state
        load()
    }

    // MARK: - Current Tab (sicher!)
    var current: BrowserTab {
        if let t = tabs.first(where: { $0.id == selectedTabID }) {
            return t
        } else {
            let new = BrowserTab()
            tabs = [new]
            selectedTabID = new.id
            return new
        }
    }

    // MARK: - New Tab
    func newTab() {
        let tab = BrowserTab()
        tabs.append(tab)
        selectedTabID = tab.id
        save()
    }

    // MARK: - Close Tab (Safari-Logik)
    func close(_ tab: BrowserTab) {
        guard let index = tabs.firstIndex(where: { $0.id == tab.id }) else {
            return
        }

        tabs.remove(at: index)

        if tabs.isEmpty {
            newTab()
        } else {
            let newIndex = max(0, index - 1)
            selectedTabID = tabs[newIndex].id
        }
        save()
    }

    // MARK: - Select
    func select(_ tab: BrowserTab) {
        selectedTabID = tab.id
        save()
    }

    // MARK: - Persistence
    private let storeKey = "TabSession.tabs"

    private func save() {
        let states = tabs.map {
            BrowserTabState(id: $0.id, url: $0.engine.currentURLString)
        }
        if let data = try? JSONEncoder().encode(states) {
            UserDefaults.standard.set(data, forKey: storeKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storeKey),
            let states = try? JSONDecoder().decode(
                [BrowserTabState].self,
                from: data
            )
        else { return }

        tabs = states.map {
            let t = BrowserTab()
            if !$0.url.isEmpty { t.engine.load($0.url) }
            return t
        }
        if let firstID = tabs.first?.id { selectedTabID = firstID }
    }
}
