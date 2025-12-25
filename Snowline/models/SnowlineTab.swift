//
//  SnowlineTab.swift
//  Snowline
//
//  Created by Tufan Cakir on 23.12.25.
//

internal import Combine
import SwiftUI
import WebKit

final class SnowlineTab: ObservableObject, Identifiable {

    let id = UUID()
    let isPrivate: Bool

    lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        if isPrivate { config.websiteDataStore = .nonPersistent() }

        let v = WKWebView(frame: .zero, configuration: config)
        v.allowsBackForwardNavigationGestures = true
        v.scrollView.keyboardDismissMode = .interactive

        // 👇 DAS IST DER WICHTIGE TEIL
        v.customUserAgent = nil // ← Safari Mobile UA benutzen

        return v
    }()


    @Published var url: URL?
    @Published var title = "New Tab"
    @Published var canGoBack = false
    @Published var canGoForward = false

    init(isPrivate: Bool) {
        self.isPrivate = isPrivate
    }

    static func normal() -> SnowlineTab { .init(isPrivate: false) }
    static func `private`() -> SnowlineTab { .init(isPrivate: true) }
}
