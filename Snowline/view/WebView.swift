//
//  WebView.swift
//  Snowline
//
//  Created by Tufan Cakir on 23.12.25.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    @ObservedObject var tab: SnowlineTab

    func makeUIView(context: Context) -> WKWebView {
        tab.webView.navigationDelegate = context.coordinator
        return tab.webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(tab: tab)
    }
}

// MARK: Coordinator
final class Coordinator: NSObject, WKNavigationDelegate {

    let tab: SnowlineTab
    init(tab: SnowlineTab) { self.tab = tab }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        tab.title = webView.title ?? "Website"
        tab.url = webView.url
        tab.canGoBack = webView.canGoBack
        tab.canGoForward = webView.canGoForward
    }
}
