//
//  SearchBar.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import SwiftUI

struct SearchBar: View {
    @ObservedObject var ui = BrowserUI.shared
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search the Web", text: $text)
        }
        .padding()
        .background(.ultraThinMaterial, in: Capsule())
        .onTapGesture {
            ui.showAddress = true
        }
    }
}
