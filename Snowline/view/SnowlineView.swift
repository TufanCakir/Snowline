//
//  SnowlineView.swift
//  Snowline
//
//  Created by Tufan Cakir on 22.12.25.
//

import SwiftUI
import WebKit

struct SnowlineView: View {

    // MARK: - Environment
    @EnvironmentObject private var themeManager: ThemeManager

    // MARK: - Storage
    @AppStorage("snowline_startpage")
    private var selectedStartPage: StartPage = .google

    @AppStorage("snowline_pending_search")
    private var pendingSearch: String = ""

    // History
    @AppStorage("snowline_history")
    private var historyData: Data = Data()

    private var history: [SearchHistoryItem] {
        get {
            (try? JSONDecoder().decode(
                [SearchHistoryItem].self,
                from: historyData
            )) ?? []
        }
        nonmutating set {
            historyData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }

    // MARK: - Focus
    @FocusState private var searchFocused: Bool

    // MARK: - Mode
    @State private var browsingMode: BrowsingMode = .normal

    // MARK: - Tabs (separat)
    @State private var normalTabs: [SnowlineTab]
    @State private var privateTabs: [SnowlineTab]

    @State private var selectedNormalTabID: UUID
    @State private var selectedPrivateTabID: UUID

    // MARK: - UI State
    @State private var searchText: String = ""
    @State private var selectedIntent: SearchIntent = .search
    @State private var showSearchSheet: Bool = false
    @State private var showTabsSheet: Bool = false

    // MARK: - Init
    init() {
        let normal = SnowlineTab.normal()
        let priv = SnowlineTab.private()

        _normalTabs = State(initialValue: [normal])
        _privateTabs = State(initialValue: [priv])

        _selectedNormalTabID = State(initialValue: normal.id)
        _selectedPrivateTabID = State(initialValue: priv.id)
    }

    // MARK: - Active bindings (abhängig vom Modus)
    private var activeTabs: Binding<[SnowlineTab]> {
        browsingMode == .normal ? $normalTabs : $privateTabs
    }

    private var activeSelectedTabID: Binding<UUID> {
        browsingMode == .normal ? $selectedNormalTabID : $selectedPrivateTabID
    }

    private var currentTabIndex: Int? {
        activeTabs.wrappedValue.firstIndex {
            $0.id == activeSelectedTabID.wrappedValue
        }
    }

    private var currentTab: Binding<SnowlineTab>? {
        guard let index = currentTabIndex else { return nil }
        return activeTabs[index]
    }

    private var isPrivateMode: Bool {
        browsingMode == .private
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {

                themeManager.backgroundColor
                    .ignoresSafeArea()
                    .onTapGesture { searchFocused = false }

                content

                // 🔒 Private Banner (optional, aber nice)
                if isPrivateMode {
                    PrivateModeBanner()
                }
            }
            .ignoresSafeArea(.keyboard)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
        }
        .onAppear(perform: handlePendingSearch)
        .sheet(isPresented: $showSearchSheet) { searchSheet }
        .sheet(isPresented: $showTabsSheet) { tabsSheet }
    }

    // MARK: - Content
    @ViewBuilder
    private var content: some View {
        if let tab = currentTab {
            if let url = tab.wrappedValue.url {
                WebView(url: url, isPrivate: tab.wrappedValue.isPrivate)
            } else {
                SnowlineStartView(
                    engine: selectedStartPage,
                    searchText: $searchText,
                    onSubmit: performSearch,
                    searchFocused: $searchFocused,
                    selectedIntent: $selectedIntent
                )
            }
        }
    }

    // MARK: - Sheets
    @ViewBuilder
    private var searchSheet: some View {
        if isPrivateMode {
            VStack(alignment: .leading, spacing: 2) {
                Text("Private browsing enabled")
                    .font(.footnote.weight(.medium))
                Text("Pages you visit won’t be saved.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding()
        } else {
            SnowlineSearchSheet(
                searchText: $searchText,
                selectedIntent: $selectedIntent,
                history: history,
                onSelectHistory: { item in
                    searchText = item.query
                    showSearchSheet = false
                    performSearch()
                },
                isFocused: $searchFocused
            )
            .presentationDetents([.height(420)])
            .presentationBackground(.ultraThinMaterial)
        }
    }

    private var tabsSheet: some View {
        List {
            ForEach(activeTabs.wrappedValue) { tab in
                Button {
                    activeSelectedTabID.wrappedValue = tab.id
                    showTabsSheet = false
                } label: {
                    HStack {
                        if tab.isPrivate {
                            Image(systemName: "lock.fill").foregroundStyle(
                                .secondary
                            )
                        }
                        Text(tab.title)
                            .lineLimit(1)
                        Spacer()
                    }
                }
            }
            .onDelete { indexSet in
                // Delete from the currently active array
                var arr = activeTabs.wrappedValue
                let removedIDs = indexSet.map { arr[$0].id }
                arr.remove(atOffsets: indexSet)

                // Ensure at least one tab remains
                if arr.isEmpty {
                    arr.append(isPrivateMode ? .private() : .normal())
                }

                activeTabs.wrappedValue = arr

                // Fix selection if selected was removed
                if removedIDs.contains(activeSelectedTabID.wrappedValue) {
                    activeSelectedTabID.wrappedValue =
                        activeTabs.wrappedValue.first!.id
                }
            }
        }
        .presentationBackground(.ultraThinMaterial)
    }

    // MARK: - Toolbar
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {

            // Mode Switch
            Button {
                browsingMode = isPrivateMode ? .normal : .private
            } label: {
                Image(systemName: isPrivateMode ? "lock.fill" : "globe")
                    .foregroundStyle(
                        isPrivateMode
                            ? .secondary : themeManager.toolbarIconColor
                    )
            }

            // History (only in normal)
            Button {
                showSearchSheet = true
            } label: {
                Image(systemName: "clock")
                    .foregroundStyle(themeManager.toolbarIconColor)
            }
            .opacity(isPrivateMode ? 0.35 : 1)
            .disabled(isPrivateMode)

            // New Tab (in current mode)
            Button {
                let tab =
                    isPrivateMode ? SnowlineTab.private() : SnowlineTab.normal()
                activeTabs.wrappedValue.append(tab)
                activeSelectedTabID.wrappedValue = tab.id
            } label: {
                Image(systemName: "plus")
                    .foregroundStyle(themeManager.toolbarIconColor)
            }

            // Tabs Overview
            Button {
                showTabsSheet = true
            } label: {
                Image(systemName: "square.on.square")
                    .foregroundStyle(themeManager.toolbarIconColor)
            }
        }
    }

    // MARK: - Search
    private func performSearch() {
        guard !searchText.isEmpty,
            let index = currentTabIndex
        else { return }

        let finalQuery = searchText + selectedIntent.querySuffix
        let url = selectedStartPage.searchURL(for: finalQuery)

        activeTabs.wrappedValue[index].url = url
        activeTabs.wrappedValue[index].title = searchText

        // Save history only in normal mode
        if !isPrivateMode {
            let item = SearchHistoryItem(
                title: searchText,
                query: searchText,
                date: Date()
            )

            let updated = ([item] + history).prefix(20)
            history = Array(updated)
        }

        searchText = ""
        searchFocused = false
    }

    // MARK: - Pending search
    private func handlePendingSearch() {
        guard !pendingSearch.isEmpty,
            let index = currentTabIndex
        else { return }

        let url = selectedStartPage.searchURL(for: pendingSearch)
        activeTabs.wrappedValue[index].url = url
        activeTabs.wrappedValue[index].title = pendingSearch
        pendingSearch = ""
    }
}

#Preview {
    SnowlineView()
        .environmentObject(ThemeManager())
}
