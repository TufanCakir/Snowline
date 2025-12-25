//
//  SnowlineStartView.swift
//  Snowline
//
//  Created by Tufan Cakir on 22.12.25.
//

import SwiftUI

struct SnowlineStartView: View {
   

    let onOpenFavorite: (URL) -> Void
    @AppStorage("snowline_favorites") private var favoritesData: Data = Data()

    private var favorites: [SnowlineFavorite] {
        get {
            (try? JSONDecoder().decode(
                [SnowlineFavorite].self,
                from: favoritesData
            )) ?? []
        }
        nonmutating set {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.9)) {
                favoritesData = (try? JSONEncoder().encode(newValue)) ?? Data()
            }
        }
    }

    let engine: StartPage
    @Binding var searchText: String
    var onSubmit: () -> Void
    @FocusState.Binding var searchFocused: Bool
    @Binding var selectedIntent: SearchIntent

    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer(minLength: geo.size.height * 0.18)

                logoBlock

                searchBlock
                    .frame(maxWidth: 420)
                    .padding(.horizontal, 28)
                    .padding(.top, 8)

                intentBlock
                    .padding(.top, 18)

                subtitleBlock
                    .padding(.top, 22)

                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
    }




    private var logoBlock: some View {
        VStack(spacing: 12) {
            Image("snowline_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .clipShape(Circle())

            Text("Snowline")
                .font(.title2.weight(.semibold))
        }
        .padding(.bottom, 28)
    }

    private var searchBlock: some View {
        SnowlineSearchBar(
            text: $searchText,
            onSubmit: onSubmit,
            isFocused: $searchFocused
        )
        .padding(.horizontal, 32)
    }

    private var intentBlock: some View {
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
    }

    private var subtitleBlock: some View {
        Text(
            "Snowline ist eine minimalistische Such-App, die dir einen klaren, fokussierten Start ins Web ermöglicht."
        )
        .font(.footnote)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
        .padding(.top, 18)
        .padding(.horizontal, 32)
    }
}
