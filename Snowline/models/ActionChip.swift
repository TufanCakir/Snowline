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
    var isSelected: Bool = false
    var action: (() -> Void)? = nil

    var body: some View {
        Button {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            action?()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: icon)
                Text(title)
            }
            .font(.footnote.weight(.semibold))
            .foregroundStyle(isSelected ? .white : .primary)
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background {
                ZStack {
                    if isSelected {
                        Capsule()
                            .fill(Color.accentColor)
                    } else {
                        Capsule()
                            .fill(.clear)
                            .background(
                                Capsule().fill(.ultraThinMaterial)
                            )
                    }
                }
                .overlay(
                    Capsule().stroke(.white.opacity(isSelected ? 0.3 : 0.1))
                )
            }
            .scaleEffect(isSelected ? 1.08 : 1)
            .animation(
                .spring(response: 0.35, dampingFraction: 0.85),
                value: isSelected
            )
        }
        .buttonStyle(.plain)
        .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
    }
}
