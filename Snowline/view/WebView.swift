//
//  WebView.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let web = WKWebView()
        web.navigationDelegate = context.coordinator
        web.allowsBackForwardNavigationGestures = true
        web.load(URLRequest(url: url))
        return web
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator: NSObject, WKNavigationDelegate {

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
        {

            guard let url = webView.url else { return }

            // 1️⃣ Capture Screenshot
            capturePage(
                webView,
                url: url,
                title: webView.title ?? url.host ?? "Website"
            )

            // 2️⃣ Index Page HTML
            webView.evaluateJavaScript(
                "document.documentElement.outerHTML.toString()"
            ) { html, _ in
                guard let html = html as? String else { return }
                Task {
                    await SearchCore.shared.indexPage(url: url, html: html)
                }
            }
        }
    }
}
