//
//  extension.swift
//  Khione
//
//  Created by Tufan Cakir on 14.12.25.
//

import SwiftUI
import UIKit

extension Color {

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
            .uppercased()

        var value: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&value)

        let r, g, b, a: Double

        switch hex.count {

        case 6: // RRGGBB
            r = Double((value >> 16) & 0xFF) / 255
            g = Double((value >> 8) & 0xFF) / 255
            b = Double(value & 0xFF) / 255
            a = 1

        case 8: // AARRGGBB
            a = Double((value >> 24) & 0xFF) / 255
            r = Double((value >> 16) & 0xFF) / 255
            g = Double((value >> 8) & 0xFF) / 255
            b = Double(value & 0xFF) / 255

        default:
            // Fallback: Apple System Accent
            self = Color.accentColor
            return
        }

        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }

    func toHex() -> String {
        let ui = UIColor(self)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        ui.getRed(&r, green: &g, blue: &b, alpha: &a)

        return String(
            format: "#%02X%02X%02X",
            Int(r * 255),
            Int(g * 255),
            Int(b * 255)
        )
    }
}
