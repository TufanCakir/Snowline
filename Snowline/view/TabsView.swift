//
//  TabsView.swift
//  Snowline
//
//  Created by Tufan Cakir on 25.12.25.
//

import SwiftUI

struct TabsView: View {
    let tabs: [SnowlineTab]
    let onSelect: (SnowlineTab) -> Void

    var body: some View {
        List {
            ForEach(tabs) { tab in
                Button {
                    onSelect(tab)
                } label: {
                    HStack {
                        if tab.isPrivate {
                            Image(systemName: "lock.fill")
                        }
                        Text(tab.title)
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Tabs")
    }
}

