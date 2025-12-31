//
//  BrowserView.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import SwiftUI

struct BrowserView: View {

    let url: URL

    var body: some View {
        WebView(url: url)
            .ignoresSafeArea()
    }
}
