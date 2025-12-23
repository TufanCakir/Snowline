//
//  SnowlineStartView.swift
//  Snowline
//
//  Created by Tufan Cakir on 22.12.25.
//

import SwiftUI

struct SnowlineStartView: View {

    let engine: StartPage
    @Binding var searchText: String
    var onSubmit: () -> Void
    @FocusState.Binding var searchFocused: Bool
    @Binding var selectedIntent: SearchIntent

    var body: some View {
        VStack(spacing: 0) {

            Spacer(minLength: 60)

            // ❄️ Logo + Title (grouped, calm)
            VStack(spacing: 12) {
                Image("snowline_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())

                Text("Snowline")
                    .font(.title2.weight(.semibold))
            }

            // ❄️ Search Bar (primary focus)
            SnowlineSearchBar(
                text: $searchText,
                onSubmit: onSubmit,
                isFocused: $searchFocused
            )
            .padding(.horizontal, 32)
            .padding(.top, 28)

            // ❄️ Intent Chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(SearchIntent.allCases) { intent in
                        SearchIntentChip(
                            intent: intent,
                            isSelected: selectedIntent == intent
                        ) {
                            selectedIntent = intent
                        }
                    }
                }
                .padding(.horizontal, 32)
            }
            .padding(.top, 14)

            // ❄️ Subtitle
            Text(
                "Snowline ist eine minimalistische Such-App, die dir einen klaren, fokussierten Start ins Web ermöglicht."
            )
            .font(.footnote)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .padding(.top, 18)
            .padding(.horizontal, 32)

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
