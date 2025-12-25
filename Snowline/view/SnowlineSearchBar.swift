//
//  SnowlineSearchBar.swift
//  Snowline
//
//  Created by Tufan Cakir on 22.12.25.
//

import SwiftUI

struct SnowlineSearchBar: View {

    @Binding var text: String
    var onSubmit: () -> Void

    @FocusState.Binding var isFocused: Bool

    var body: some View {
        HStack(spacing: 10) {

            Image(systemName: "magnifyingglass")
                .foregroundStyle(isFocused ? .primary : .secondary)

            TextField("Search or enter website", text: $text)
                .focused($isFocused)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .submitLabel(.search)
                .onSubmit(onSubmit)
                .frame(height: 50)
                .frame(maxWidth: .infinity)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background {
            ZStack {

                // ❄️ Glass base
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.ultraThinMaterial)

                // ❄️ Ice highlight border
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(isFocused ? 0.28 : 0.12),
                                Color.white.opacity(0.04),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(isFocused ? 0.22 : 0.10),
                radius: isFocused ? 18 : 12,
                y: 10)
    }
}
