//
//  PrivateModeBanner.swift
//  Snowline
//
//  Created by Tufan Cakir on 23.12.25.
//

import SwiftUI

struct PrivateModeBanner: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "lock.fill")
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 2) {
                Text("Private browsing enabled")
                    .font(.footnote.weight(.medium))

                Text("Pages you visit won’t be saved.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)  // ❄️ DAS
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}
