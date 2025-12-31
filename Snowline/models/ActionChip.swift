//
//  ActionChip.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import SwiftUI

struct ActionChip: View {

    let icon: String
    let title: String
    var action: (() -> Void)? = nil

    var body: some View {
        Button {
            action?()
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))

                Text(title)
                    .font(.footnote.weight(.semibold))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(chipBackground)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
    }

    private var chipBackground: some View {
        ZStack {
            Capsule().fill(.ultraThinMaterial)
            Capsule().stroke(.white.opacity(0.08))
        }
    }
}
