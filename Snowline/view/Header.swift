//
//  Header.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import SwiftUI

struct Header: View {
    @State private var move = false

    var body: some View {
        LinearGradient(
            colors: [.black, .indigo, .purple],
            startPoint: move ? .topLeading : .bottomTrailing,
            endPoint: move ? .bottomTrailing : .topLeading
        )
        .ignoresSafeArea()
        .animation(
            .linear(duration: 12).repeatForever(autoreverses: true),
            value: move
        )
        .onAppear { move = true }
    }
}
