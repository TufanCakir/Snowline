//
//  SnowlineView.swift
//  Snowline
//
//  Created by Tufan Cakir on 22.12.25.
//

import SwiftUI
import WebKit
import Foundation

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
    
    // Favorites
    @AppStorage("snowline_favorites")
    private var favoritesData: Data = Data()
    
    private var favorites: [SnowlineFavorite] {
        get {
            (try? JSONDecoder().decode(
                [SnowlineFavorite].self,
                from: favoritesData
            )) ?? []
        }
        nonmutating set {
            favoritesData = (try? JSONEncoder().encode(newValue)) ?? Data()
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
    @State private var showFavorites = false
    @StateObject private var favoritesStore = FavoritesStore()
    @State private var showPrivacy = false
    @State private var nightReading = false
    @State private var browserWebView: WKWebView?
    @State private var addressText = ""
    @State private var scene: BrowserScene = .start
    
    
    // MARK: - Init
    init() {
        let normal = SnowlineTab.normal()
        let priv   = SnowlineTab.private()
        
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
        activeTabs.wrappedValue.firstIndex { $0.id == activeSelectedTabID.wrappedValue }
    }
    
    private var currentTab: Binding<SnowlineTab>? {
        guard let index = currentTabIndex else { return nil }
        return activeTabs[index]
    }
    
    private var isPrivateMode: Bool { browsingMode == .private }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                TabView(selection: $scene) {
                    startPage
                        .tag(BrowserScene.start)
                        .tabItem { Label("Home", systemImage: "house") }
                    
                    if let tab = currentTab?.wrappedValue {
                        WebView(tab: tab)
                            .tag(BrowserScene.web)
                            .tabItem { Label("Web", systemImage: "globe") }
                    }
                    
                    SnowlineFavoritesView { openFavorite($0) }
                        .tag(BrowserScene.favorites)
                        .tabItem { Label("Favorites", systemImage: "star") }
                    
                    TabsView(tabs: activeTabs.wrappedValue) { activeSelectedTabID.wrappedValue = $0.id }
                        .tag(BrowserScene.tabs)
                        .tabItem { Label("Tabs", systemImage: "square.on.square") }
                    
                    
                }
                
                // 👇 Floating Safari Bar lives OUTSIDE TabView safe area
                browserOverlayBar
                
            }
            .ignoresSafeArea(.keyboard)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
        }
        .onAppear(perform: handlePendingSearch)
        .onReceive(NotificationCenter.default.publisher(for: .snowlineBackToStart)) { _ in
            scene = .start
            addressText = ""
            searchText = ""
            searchFocused = true
        }
        .sheet(isPresented: $showSearchSheet) { searchSheet }
        .sheet(isPresented: $showTabsSheet) { tabsSheet }
        .sheet(isPresented: $showFavorites) {
            NavigationStack {
                SnowlineFavoritesView { url in
                    openFavorite(url)
                    showFavorites = false
                }
            }
        }
        .sheet(isPresented: $showPrivacy) {
            NavigationStack { SnowlinePrivacyView() }
        }
    }
    
    private var browserOverlayBar: some View {
        GeometryReader { geo in
            VStack {
                Spacer()

                if scene == .web {
                    addressBar
                        .padding(12)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 26))
                        .shadow(radius: 22)
                        .padding(.horizontal, 14)
                        .padding(.bottom, geo.safeAreaInsets.bottom + 60)   // ← MAGIC LINE
                }
            }
            .ignoresSafeArea()
        }
    }

 
    private var addressBar: some View {
        HStack(spacing: 14) {

            navButton("chevron.left", !(currentTab?.wrappedValue.canGoBack ?? false)) {
                currentTab?.wrappedValue.webView.goBack()
            }

            navButton("chevron.right", !(currentTab?.wrappedValue.canGoForward ?? false)) {
                currentTab?.wrappedValue.webView.goForward()
            }



            TextField("Search or website", text: $addressText, onCommit: loadAddress)
                .padding(10)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 14))

            navButton("arrow.clockwise", false) {
                currentTab?.wrappedValue.webView.reload()
            }
        }
        .padding(.horizontal)
    }

    private func syncAddressBar() {
        guard let webView = browserWebView,
              let url = webView.url else { return }
        addressText = url.absoluteString
    }
    
    private func navButton(_ icon: String, _ disabled: Bool, _ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title3)
                .opacity(disabled ? 0.3 : 1)
        }
        .disabled(disabled)
    }
    
    private func loadAddress() {
        guard let tab = currentTab?.wrappedValue else { return }
        let input = addressText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        // 1. Echte URL?
        if let url = URL(string: input), input.contains(".") {
            let finalURL = input.hasPrefix("http") ? url : URL(string: "https://\(input)")!
            tab.webView.load(URLRequest(url: finalURL))
            addressText = finalURL.absoluteString
            return
        }
        
        // 2. Sonst → Suche
        let searchURL = selectedStartPage.searchURL(for: input)
        tab.webView.load(URLRequest(url: searchURL))
        addressText = searchURL.absoluteString
    }
    
    private func newTab() {
        let tab = isPrivateMode ? SnowlineTab.private() : SnowlineTab.normal()
        activeTabs.wrappedValue.append(tab)
        activeSelectedTabID.wrappedValue = tab.id
    }
    
    private func newPrivateTab() {
        browsingMode = .private
        let tab = SnowlineTab.private()
        privateTabs.append(tab)
        selectedPrivateTabID = tab.id
    }
    
    private func addFavorite() {
        guard let tab = currentTab?.wrappedValue,
              let url = tab.webView.url else { return }
        
        favorites.insert(
            SnowlineFavorite(
                id: UUID(),
                title: tab.title,
                url: url,
                created: Date(),
                colorHex: url.host?.hashColorHex()
            ),
            at: 0
        )
        
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }
    
    // MARK: - Content
    @ViewBuilder
    private var content: some View {
        switch scene {
        case .start:
            startPage

        case .web:
            if let tab = currentTab?.wrappedValue {
                WebView(tab: tab)
            }

        case .favorites:
            SnowlineFavoritesView { openFavorite($0) }

        case .tabs:
            TabsView(tabs: activeTabs.wrappedValue) {
                activeSelectedTabID.wrappedValue = $0.id
            }

        case .menu:
            MenuView(
                onNewTab: newTab,
                onPrivateTab: newPrivateTab,
                onNightMode: { nightReading.toggle() },
                onPrivacy: { showPrivacy = true }
            )
        }
    }


    private var startPage: some View {
        SnowlineStartView(
            onOpenFavorite: openFavorite,
            engine: selectedStartPage,
            searchText: $searchText,
            onSubmit: performSearch,
            searchFocused: $searchFocused,
            selectedIntent: $selectedIntent
        )
    }
    
    private func openFavorite(_ url: URL) {
        guard let tab = currentTab?.wrappedValue else { return }
        tab.webView.load(URLRequest(url: url))
        tab.title = url.host ?? "Website"
        addressText = url.absoluteString
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
                            Image(systemName: "lock.fill").foregroundStyle(.secondary)
                        }
                        Text(tab.title)
                            .lineLimit(1)
                        Spacer()
                    }
                }
            }
            .onDelete { indexSet in
                var arr = activeTabs.wrappedValue
                let removedIDs = indexSet.map { arr[$0].id }
                arr.remove(atOffsets: indexSet)
                if arr.isEmpty {
                    arr.append(isPrivateMode ? SnowlineTab.private() : SnowlineTab.normal())
                }
                activeTabs.wrappedValue = arr
                if removedIDs.contains(activeSelectedTabID.wrappedValue) {
                    activeSelectedTabID.wrappedValue = activeTabs.wrappedValue.first!.id
                }
            }
        }
        .presentationBackground(.ultraThinMaterial)
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {

            Button {
                browsingMode = isPrivateMode ? .normal : .private
            } label: {
                Image(systemName: isPrivateMode ? "lock.fill" : "globe")
                    .foregroundStyle(isPrivateMode ? .secondary : themeManager.toolbarIconColor)
            }

            Menu {
                Button {
                    newTab()
                } label: {
                    Label("New Tab", systemImage: "plus")
                }

                Button {
                    newPrivateTab()
                } label: {
                    Label("Private Tab", systemImage: "lock")
                }

                Divider()

                Button {
                    nightReading.toggle()
                } label: {
                    Label("Night Reading", systemImage: "moon.fill")
                }

                Divider()

                Button {
                    showPrivacy = true
                } label: {
                    Label("Privacy Info", systemImage: "shield")
                }

            } label: {
                Image(systemName: "ellipsis.circle.fill")
            }
        }
    }

    
    private func enableReaderMode() {}
    private func enableNightMode() {}
    private func enableFocusMode() {}
    private func showPrivacyInfo() {}
    
    private func goHome() {
        guard let index = currentTabIndex else { return }

        let tab = activeTabs.wrappedValue[index]
        tab.webView.load(URLRequest(url: selectedStartPage.homeURL))

        tab.title = "New Tab"
        tab.url = nil

        scene = .start
        addressText = ""
        searchText = ""
        searchFocused = true
    }

    
    // MARK: - Search
    private func performSearch() {
        guard let tab = currentTab?.wrappedValue else { return }

        let url = selectedStartPage.searchURL(for: searchText + selectedIntent.querySuffix)
        tab.webView.load(URLRequest(url: url))

        addressText = url.absoluteString
        scene = .web
        searchText = ""
        searchFocused = false
    }

    
    // MARK: - Pending search
    private func handlePendingSearch() {
        guard !pendingSearch.isEmpty, let index = currentTabIndex else { return }
        let tab = activeTabs.wrappedValue[index]
        let url = selectedStartPage.searchURL(for: pendingSearch)
        tab.webView.load(URLRequest(url: url))
        tab.title = pendingSearch
        pendingSearch = ""
    }
    
    private func menuButton(_ title: String, _ icon: String, _ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}

extension Notification.Name {
    static let snowlineURLChanged   = Notification.Name("snowlineURLChanged")
    static let snowlineBackToStart  = Notification.Name("snowlineBackToStart")
}

extension String {
    func hashColorHex() -> String {
        let hash = abs(self.hashValue)
        let r = (hash & 0xFF0000) >> 16
        let g = (hash & 0x00FF00) >> 8
        let b = (hash & 0x0000FF)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}

#Preview {
    SnowlineView()
        .environmentObject(ThemeManager())
        .environmentObject(FavoritesStore())
}

