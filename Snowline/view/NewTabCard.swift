//
//  NewTabCard.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import SwiftUI

struct NewTabCard: View {

    let tab: NewTabStore.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            if let data = tab.screenshot,
                let img = UIImage(data: data)
            {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 110)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            Text(tab.title)
                .font(.footnote.bold())
                .lineLimit(2)

            Text(tab.url)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(1)

            HStack {
                Button {
                    NewTabStore.shared.toggleFavorite(tab)
                } label: {
                    Image(systemName: tab.isFavorite ? "star.fill" : "star")
                        .foregroundStyle(.yellow)
                }

                Spacer()

                Text(tab.date, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(10)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18))
    }
}
