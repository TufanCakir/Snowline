//
//  SearchIntentChip.swift
//  Snowline
//
//  Created by Tufan Cakir on 22.12.25.
//

import SwiftUI

struct SearchIntentChip: View {

    @EnvironmentObject private var themeManager: ThemeManager

    let intent: SearchIntent
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: intent.icon)
                    .font(.caption)

                Text(intent.title)
                    .font(.caption.weight(.medium))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .foregroundStyle(foreground)
            .background(background)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(border, lineWidth: isSelected ? 1.2 : 0.6)
            )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }

    // MARK: - Theme Logic

    private var foreground: Color {
        isSelected
        ? themeManager.accentColor
        : .secondary
    }

    private var background: Color {
        isSelected
        ? themeManager.accentColor.opacity(0.15)
        : Color.secondary.opacity(0.08)
    }

    private var border: Color {
        isSelected
        ? themeManager.accentColor
        : Color.secondary.opacity(0.3)
    }
}

