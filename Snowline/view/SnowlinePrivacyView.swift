//
//  SnowlinePrivacyView.swift
//  Snowline
//
//  Created by Tufan Cakir on 24.12.25.
//

import SwiftUI

struct SnowlinePrivacyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {

                Label("Privacy by Design", systemImage: "lock.shield")
                    .font(.title2.weight(.semibold))

                privacyRow("Kein Tracking", "location.slash", "Snowline verfolgt keine Nutzeraktivitäten.")
                privacyRow("Private Tabs", "eye.slash", "Private Tabs speichern keine Daten.")
                privacyRow("Keine Accounts", "person.crop.circle.badge.xmark", "Du brauchst kein Konto.")
                privacyRow("Lokale Speicherung", "externaldrive", "Alle Favoriten & History bleiben auf deinem Gerät.")
                privacyRow("Keine Werbung", "nosign", "Snowline enthält keine Tracker oder Werbenetzwerke.")

                Spacer(minLength: 40)
            }
            .padding(24)
        }
        .navigationTitle("Datenschutz")
        .background(.ultraThinMaterial)
    }

    private func privacyRow(_ title: String, _ icon: String, _ text: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.secondary)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline)
                Text(text)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
