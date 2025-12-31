//
//  resultsView.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import SwiftUI

struct ResultsView: View {
    // Provide results as input to this view
    let results: [Result]

    var body: some View {
        LazyVStack(spacing: 14) {
            ForEach(results, id: \.url) { result in
                ResultCard(result: result)
                    .transition(.asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity),
                        removal: .opacity
                    ))
            }
        }
    }
}
#Preview {
    // Replace with your own sample data if available
    ResultsView(results: [])
}

