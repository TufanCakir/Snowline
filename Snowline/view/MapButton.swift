//
//  MapButton.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import SwiftUI

struct MapButton: View {

    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: tap) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 50))
        }
        .buttonStyle(.plain)
    }

    private func tap() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        action()
    }
}

#Preview {
    MapButton(icon: "snowflake") {

    }
}
