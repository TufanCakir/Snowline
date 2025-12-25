//
//  MenuView.swift
//  Snowline
//
//  Created by Tufan Cakir on 25.12.25.
//

import SwiftUI

struct MenuView: View {

    let onNewTab: () -> Void
    let onPrivateTab: () -> Void
    let onNightMode: () -> Void
    let onPrivacy: () -> Void

    var body: some View {
        NavigationStack {
            VStack {
                Menu {
                    Section {
                        Button(action: onNewTab) {
                            Label("New Tab", systemImage: "plus")
                        }
                        Button(action: onPrivateTab) {
                            Label("Private Tab", systemImage: "lock")
                        }
                    }

                    Section {
                        Button(action: onNightMode) {
                            Label("Night Reading", systemImage: "moon.fill")
                        }
                    }

                    Section {
                        Button(action: onPrivacy) {
                            Label("Privacy Info", systemImage: "shield")
                        }
                    }
                } label: {
                    Label("Menu", systemImage: "ellipsis.circle")
                        .font(.title2)
                }
                .menuStyle(.automatic)
                .padding()

                Spacer()
            }
            .navigationTitle("Menu")
        }
    }
}
