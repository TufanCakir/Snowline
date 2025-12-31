//
//  ResultCard.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import SwiftUI

struct ResultCard: View {
    private struct IdentifiableURL: Identifiable {
        let id = UUID()
        let url: URL
    }

    let result: Result
    @StateObject private var theme = SnowlineThemeManager.shared
    @State private var openURL: IdentifiableURL?

    var body: some View {
        Button {
            openURL = IdentifiableURL(url: result.url)
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                Text(result.title)
                    .foregroundColor(Color(system: theme.theme.textPrimary))
                    .font(.headline)

                Text(result.url.host ?? "")
                    .foregroundColor(Color(system: theme.theme.textSecondary))
                    .font(.caption2)

                Text(result.snippet)
                    .foregroundColor(Color(system: theme.theme.textPrimary))
                    .font(.callout)
            }
            .padding()
            .background(
                Color(system: theme.theme.card),
                in: RoundedRectangle(cornerRadius: 22)
            )
        }
        .buttonStyle(.plain)
        .sheet(item: $openURL) { identifiable in
            BrowserView(url: identifiable.url)
        }
    }
}
