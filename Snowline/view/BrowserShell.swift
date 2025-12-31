//
//  BrowserShell.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import SwiftUI
import WebKit

struct BrowserShell: View {

    let url: URL
    @Environment(\.dismiss) private var dismiss
    @State private var webView = WKWebView()

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("Close") { dismiss() }
                Spacer()
                Text(url.host ?? "")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Button {
                    webView.reload()
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
            .padding(.horizontal)
            .padding(.top, 14)
            .padding(.bottom, 10)
            .background(.ultraThinMaterial)

            Divider()

            WebContainer(webView: webView, url: url)
        }
        .ignoresSafeArea(.keyboard)  // keep keyboard normal
    }
}
