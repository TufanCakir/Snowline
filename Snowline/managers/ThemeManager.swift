//
//  ThemeManager.swift
//  Snowline
//
//  Created by Tufan Cakir on 27.12.25.
//

internal import Combine
import Foundation
import SwiftUI

@MainActor
final class ThemeManager: ObservableObject {

    static let shared = ThemeManager()

    struct Theme {
        let background: UIColor
        let card: UIColor
        let accent: UIColor
        let textPrimary: UIColor
        let textSecondary: UIColor
        let separator: UIColor
    }

    @Published var theme = Theme(
        background: .systemBackground,
        card: .secondarySystemBackground,
        accent: .systemBlue,
        textPrimary: .label,
        textSecondary: .secondaryLabel,
        separator: .separator
    )

    func load(json: ThemeJSON) {
        theme = json.toTheme()
    }
}

struct ThemeJSON: Codable {
    let background: String
    let card: String
    let accent: String
    let textPrimary: String
    let textSecondary: String
    let separator: String

    func toTheme() -> ThemeManager.Theme {
        .init(
            background: UIColor(named: background) ?? UIColor.systemBackground,
            card: UIColor(named: card) ?? UIColor.secondarySystemBackground,
            accent: UIColor(named: accent) ?? UIColor.systemBlue,
            textPrimary: UIColor(named: textPrimary) ?? UIColor.label,
            textSecondary: UIColor(named: textSecondary)
                ?? UIColor.secondaryLabel,
            separator: UIColor(named: separator) ?? UIColor.separator
        )
    }
}
