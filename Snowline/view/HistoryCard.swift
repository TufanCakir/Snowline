//
//  HistoryCard.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import SwiftUI

struct HistoryCard: View {

    let entry: HistoryStore.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            if let data = entry.screenshot,
                let img = UIImage(data: data)
            {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 110)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            Text(entry.title)
                .font(.footnote.bold())
                .lineLimit(2)

            Text(entry.url)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(1)

            HStack {
                Button {
                    HistoryStore.shared.toggleFavorite(entry)
                } label: {
                    Image(systemName: entry.isFavorite ? "star.fill" : "star")
                        .foregroundStyle(.yellow)
                }

                Spacer()

                Text(entry.date, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18))
    }
}
