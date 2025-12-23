//
//  SnowlineSearchShee.swift
//  Snowline
//
//  Created by Tufan Cakir on 22.12.25.
//

import SwiftUI

struct SnowlineSearchSheet: View {

    // ❄️ History Search (lokal)
    @State private var historySearchText = ""

    @Binding var searchText: String
    @Binding var selectedIntent: SearchIntent

    let history: [SearchHistoryItem]
    var onSelectHistory: (SearchHistoryItem) -> Void

    @FocusState.Binding var isFocused: Bool

    // ❄️ Gefilterter Verlauf
    private var filteredHistory: [SearchHistoryItem] {
        guard !historySearchText.isEmpty else { return history }

        return history.filter {
            $0.title.localizedCaseInsensitiveContains(historySearchText)
                || $0.query.localizedCaseInsensitiveContains(historySearchText)
        }
    }

    var body: some View {
        VStack(spacing: 16) {

            Capsule()
                .fill(Color.white.opacity(0.25))
                .frame(width: 40, height: 5)
                .padding(.top, 8)

            // ❄️ History SearchBar (NICHT Web)
            HStack(spacing: 10) {
                Image(systemName: "clock")
                    .foregroundStyle(.secondary)

                TextField("Search history", text: $historySearchText)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)

                if !historySearchText.isEmpty {
                    Button {
                        historySearchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 18))

            // ❄️ History List
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(filteredHistory) { item in
                        Button {
                            onSelectHistory(item)
                        } label: {
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundStyle(.secondary)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.title)
                                        .lineLimit(1)

                                    Text(item.date, style: .date)
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()
                            }
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                }
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }
}
