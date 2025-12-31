//
//  ClockView.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import SwiftUI

struct ClockView: View {
    let time: String

    var body: some View {
        Text(time)
            .font(.system(size: 80, weight: .semibold, design: .rounded))
            .frame(width: 350)
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 50))
    }
}

#Preview {
    ClockView(time: "12:34")
}
