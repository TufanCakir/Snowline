//
//  WebView.swift
//  Snowline
//
//  Created by Tufan Cakir on 17.12.25.
//

import SwiftUI
internal import WebKit

struct WebView: UIViewRepresentable {
    let webView: WKWebView

    func makeUIView(context: Context) -> WKWebView {
        webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
