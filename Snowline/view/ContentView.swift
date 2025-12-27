//
//  BrowserView.swift
//  Snowline
//
//  Created by Tufan Cakir on 22.12.25.
//

import SwiftUI
internal import WebKit

struct ContentView: View {

    @State private var address = ""
    @StateObject private var tabSession = TabSession()

    @State private var isShowingWeb = false
    @State private var showingTabs = false

    private var engine: WebEngine { tabSession.current.engine }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground).ignoresSafeArea()

                VStack(spacing: 0) {

                    Group {
                        if isShowingWeb {
                            WebView(webView: engine.webView)
                                .id(tabSession.selectedTabID)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            startSearch
                        }
                    }

                    Divider()
                    addressBar
                }

                if showingTabs {
                    TabsOverlay(showing: $showingTabs)
                        .environmentObject(tabSession)
                        .zIndex(10)
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.9), value: showingTabs)
            .onReceive(NotificationCenter.default.publisher(for: .tabDidSelect)) { _ in
                isShowingWeb = true
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        AccountView()
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .font(.title3)
                    }
                }
            }
        }
    }


    private var addressBar: some View {
        HStack(spacing: 14) {

            bar("house") {
                tabSession.newTab()  // ← Neuer leerer Tab = Home
                isShowingWeb = false
                address = ""
            }

            bar("chevron.left", disabled: !engine.canGoBack) { engine.goBack() }
            bar("chevron.right", disabled: !engine.canGoForward) {
                engine.goForward()
            }
            bar("arrow.clockwise") { engine.reload() }

            TextField(
                "Search or enter website",
                text: Binding(
                    get: { engine.currentURLString },
                    set: { engine.currentURLString = $0 }
                )
            )
            .onSubmit { engine.load(engine.currentURLString) }

            Menu {
                Button("New Tab", systemImage: "plus.square") {
                    tabSession.newTab()
                    isShowingWeb = false
                    address = ""
                }

                Button("All Tabs", systemImage: "square.on.square") {
                    showingTabs = true
                }

                Button("Reload", systemImage: "arrow.clockwise") {
                    engine.reload()
                }
                Button("Stop", systemImage: "xmark") { engine.stop() }

                if let url = engine.webView.url {
                    Button("Share", systemImage: "square.and.arrow.up") {
                        share(url)
                    }
                }

            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
        .padding()
        .background(.ultraThinMaterial)
    }

    // MARK: Start Search (Center)

    private var startSearch: some View {
        VStack {
            Spacer()

            VStack(spacing: 18) {
                Text("Snowline")
                    .font(.largeTitle.weight(.semibold))

                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                    TextField("Search or enter website", text: $address)
                        .onSubmit(load)
                }
                .padding()
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }

            Spacer()
        }
    }

    private func bar(
        _ icon: String,
        disabled: Bool = false,
        _ action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .frame(width: 30, height: 30)
                .opacity(disabled ? 0.3 : 1)
        }
        .disabled(disabled)
    }

    private func load() {
        engine.load(address)
        isShowingWeb = true
    }

    // MARK: - Share
    private func share(_ url: URL) {
        let vc = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?
            .rootViewController?
            .present(vc, animated: true)
    }
}

#Preview {
    ContentView()
        .environmentObject(ThemeManager())
}

