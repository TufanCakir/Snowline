//
//  WebSnapshot.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

internal import UIKit
import WebKit

func capturePage(_ webView: WKWebView, url: URL, title: String) {

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {

        let config = WKSnapshotConfiguration()
        config.afterScreenUpdates = true

        webView.takeSnapshot(with: config) { image, _ in
            guard let img = image else { return }

            HistoryStore.shared.save(
                url: url,
                title: title,
                screenshot: img
            )
        }
    }
}
