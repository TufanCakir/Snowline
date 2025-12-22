//
//  SnowballShape.swift
//  Snowline
//
//  Created by Tufan Cakir on 22.12.25.
//

import SwiftUI

struct SnowballShape: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let size = min(rect.width, rect.height)
        let radius = size * 0.36

        let center = CGPoint(
            x: rect.midX - size * 0.12,
            y: rect.midY
        )

        // ❄️ Main Snowball
        path.addEllipse(
            in: CGRect(
                x: center.x - radius,
                y: center.y - radius,
                width: radius * 2,
                height: radius * 2
            )
        )

        // 💨 Main Trail (thicker)
        path.move(to: CGPoint(x: center.x + radius * 0.9, y: center.y))
        path.addCurve(
            to: CGPoint(x: rect.maxX, y: rect.midY - size * 0.25),
            control1: CGPoint(x: rect.midX + size * 0.2, y: rect.midY),
            control2: CGPoint(
                x: rect.maxX - size * 0.05,
                y: rect.midY - size * 0.2
            )
        )

        // 💨 Secondary Trail (lighter / higher)
        path.move(
            to: CGPoint(x: center.x + radius * 0.6, y: center.y - radius * 0.3)
        )
        path.addCurve(
            to: CGPoint(x: rect.maxX - size * 0.15, y: rect.midY - size * 0.45),
            control1: CGPoint(
                x: rect.midX + size * 0.15,
                y: rect.midY - size * 0.3
            ),
            control2: CGPoint(
                x: rect.maxX - size * 0.1,
                y: rect.midY - size * 0.4
            )
        )

        return path
    }
}
