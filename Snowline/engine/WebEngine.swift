//
//  WebEngine.swift
//  Snowline
//
//  Created by Tufan Cakir on 27.12.25.
//

import Combine
import SwiftUI
internal import WebKit

@MainActor
final class WebEngine: NSObject, ObservableObject, WKNavigationDelegate {

    // MARK: - Core WebView
    @Published private(set) var webView: WKWebView

    // MARK: - Live Browser State
    @Published var currentURLString: String = ""
    @Published var canGoBack: Bool = false
    @Published var canGoForward: Bool = false

    // Snapshot for Tab Preview
    var onSnapshot: ((UIImage?) -> Void)?

    // MARK: - Init
    override init() {
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = true

        let web = WKWebView(frame: .zero, configuration: config)
        web.allowsBackForwardNavigationGestures = true
        web.scrollView.keyboardDismissMode = .interactive
        web.isOpaque = false
        web.backgroundColor = .clear

        self.webView = web
        super.init()

        web.navigationDelegate = self
    }

    // MARK: - Load / Search
    func load(_ input: String) {
        let text = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        let url: URL
        if text.contains(".") {
            url = URL(
                string: text.hasPrefix("http") ? text : "https://\(text)"
            )!
        } else {
            let q =
                text.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed
                ) ?? text
            url = URL(string: "https://www.google.com/search?q=\(q)")!
        }

        webView.load(URLRequest(url: url))
    }

    // MARK: - WKNavigationDelegate
    func webView(
        _ webView: WKWebView,
        didStartProvisionalNavigation navigation: WKNavigation!
    ) {
        updateState()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateState()
        captureSnapshot()
    }

    // MARK: - State Update
    private func updateState() {
        currentURLString = webView.url?.absoluteString ?? ""
        canGoBack = webView.canGoBack
        canGoForward = webView.canGoForward
    }

    // MARK: - Controls
    func goBack() { webView.goBack() }
    func goForward() { webView.goForward() }
    func reload() { webView.reload() }
    func stop() { webView.stopLoading() }

    // MARK: - Snapshot for Tabs Grid
    private func captureSnapshot() {
        let config = WKSnapshotConfiguration()
        config.rect = webView.bounds

        webView.takeSnapshot(with: config) { [weak self] image, _ in
            self?.onSnapshot?(image)
        }
    }
}
