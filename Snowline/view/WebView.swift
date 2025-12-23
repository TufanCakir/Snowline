//
//  WebView.swift
//  Snowline
//
//  Created by Tufan Cakir on 23.12.25.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

    let url: URL
    let isPrivate: Bool

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()

        if isPrivate {
            config.websiteDataStore = .nonPersistent()  // 🔒 DAS ist Private Mode
        }

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
