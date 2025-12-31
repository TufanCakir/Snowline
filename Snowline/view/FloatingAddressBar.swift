//
//  FloatingAddressBar.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import SwiftUI
import WebKit

struct FloatingAddressBar: View {

    @ObservedObject var ui = BrowserUI.shared
    @Binding var query: String

    var body: some View {
        if ui.showAddress {
            VStack {
                Spacer()

                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(.secondary)

                    TextField("Search or enter website", text: $query)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)

                    Button("Cancel") { ui.showAddress = false }
                }
                .padding()
                .background(.ultraThinMaterial, in: Capsule())
                .padding()
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(
                    .spring(response: 0.35, dampingFraction: 0.9),
                    value: ui.showAddress
                )
            }
        }
    }
}
