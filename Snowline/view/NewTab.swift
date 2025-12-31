//
//  NewTab.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import SwiftUI

struct NewTab: View {

    @ObservedObject private var store = NewTabStore.shared
    @Environment(\.dismiss) private var dismiss

    let columns = [GridItem(.adaptive(minimum: 160), spacing: 16)]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(store.entries) { tab in
                        VStack(alignment: .leading, spacing: 8) {
                            Button {
                                if let url = URL(string: tab.url) {
                                    TabRouter.shared.activeURL = url
                                }
                            } label: {
                                NewTabCard(tab: tab)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("New Tabs")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}
