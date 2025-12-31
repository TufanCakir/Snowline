//
//  Theme.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

internal import Combine
import SwiftUI

struct Theme: Decodable {
    let background: String
    let card: String
    let accent: String
    let textPrimary: String
    let textSecondary: String
    let separator: String
}

final class SnowlineThemeManager: ObservableObject {
    static let shared = SnowlineThemeManager()
    @Published var theme: Theme = .default

    private init() {
        load()
    }

    private func load() {
        guard
            let url = Bundle.main.url(
                forResource: "snowline_theme",
                withExtension: "json"
            ),
            let data = try? Data(contentsOf: url),
            let t = try? JSONDecoder().decode(Theme.self, from: data)
        else { return }
        theme = t
    }
}

extension Theme {
    static let `default` = Theme(
        background: "systemBackground",
        card: "secondarySystemBackground",
        accent: "systemBlue",
        textPrimary: "label",
        textSecondary: "secondaryLabel",
        separator: "separator"
    )
}

extension Color {
    init(system name: String) {
        self = Color(UIColor.value(name))
    }
}

extension UIColor {
    static func value(_ name: String) -> UIColor {
        switch name {
        case "systemBackground": return .systemBackground
        case "secondarySystemBackground": return .secondarySystemBackground
        case "label": return .label
        case "secondaryLabel": return .secondaryLabel
        case "systemBlue": return .systemBlue
        case "separator": return .separator
        default: return .label
        }
    }
}
