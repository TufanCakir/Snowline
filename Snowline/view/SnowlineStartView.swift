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
    @FocusState.Binding var searchFocused: Bool  // 👈 NEU
    @Binding var selectedIntent: SearchIntent

    var body: some View {
        VStack {
            Spacer()

            HStack(spacing: 16) {
                Image("snowline_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())

                Text("Snowline")
                    .font(.title3.weight(.medium))
            }

            SnowlineSearchBar(
                text: $searchText,
                onSubmit: onSubmit,
                isFocused: $searchFocused  // 👈 DURCHREICHEN
            )
            .padding(.horizontal, 32)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
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
            .padding(.top, 12)


            Text("Search using your preferred engine")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.top, 12)

            Spacer()
        }
    }
}
