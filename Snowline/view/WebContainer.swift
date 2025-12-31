//
//  WebContainer.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import SwiftUI
import WebKit

struct WebContainer: UIViewRepresentable {

    let webView: WKWebView
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
