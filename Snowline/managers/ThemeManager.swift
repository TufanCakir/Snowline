//
//  ThemeManager.swift
//  Snowline
//
//  Created by Tufan Cakir on 22.12.25.
//

internal import Combine
import SwiftUI

@MainActor
final class ThemeManager: ObservableObject {

    // MARK: - Stored Data
    @Published private(set) var themes: [AppTheme]

    @AppStorage("selectedThemeID")
    private var selectedThemeID: String = "system"

    // MARK: - Init
    init() {
        let loadedThemes = Bundle.main.loadThemes()
        self.themes =
            loadedThemes.isEmpty
            ? [ThemeManager.fallbackTheme]
            : loadedThemes
    }

    // MARK: - Selected Theme
    var selectedTheme: AppTheme {
        themes.first { $0.id == selectedThemeID }
            ?? themes.first { $0.id == "system" }
            ?? themes.first!
    }

    // MARK: - Background Color
    var backgroundColor: Color {
        guard
            let bg = selectedTheme.backgroundColor?
                .trimmingCharacters(in: .whitespacesAndNewlines),
            !bg.isEmpty,
            selectedTheme.id != "system"
        else {
            return Color(.systemBackground)
        }

        return Color(hex: bg)
    }

    // MARK: - Color Scheme
    var colorScheme: ColorScheme? {
        switch selectedTheme.preferredScheme {
        case "light":
            return .light
        case "dark":
            return .dark
        default:
            return nil  // system
        }
    }

    // MARK: - Accent Color
    var accentColor: Color {
        let hex = selectedTheme.accentColor
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard
            !hex.isEmpty,
            selectedTheme.id != "system"
        else {
            return .accentColor
        }

        return Color(hex: hex)
    }

    // MARK: - Public API
    func selectTheme(_ theme: AppTheme) {
        guard theme.id != selectedThemeID else { return }
        selectedThemeID = theme.id
    }
}

extension ThemeManager {

    fileprivate static let fallbackTheme = AppTheme(
        id: "system",
        name: "System",
        icon: "circle.lefthalf.filled",
        accentColor: "",
        preferredScheme: "system",
        backgroundColor: nil
    )
}

extension ThemeManager {

    /// Hauptfarbe für Toolbar-Icons
    var toolbarIconColor: Color {
        // Wenn Theme eine AccentColor hat → nutze sie
        let hex = selectedTheme.accentColor
            .trimmingCharacters(in: .whitespacesAndNewlines)

        if !hex.isEmpty, selectedTheme.id != "system" {
            return Color(hex: hex)
        }

        // Fallback je nach Scheme
        return colorScheme == .dark ? .white : .black
    }

    /// Sekundäre Icons (z. B. deaktiviert)
    var toolbarSecondaryIconColor: Color {
        toolbarIconColor.opacity(0.6)
    }
}

extension ThemeManager {

    func startPageIconColor(isSelected: Bool) -> Color {
        if isSelected {
            return accentColor
        }

        // Sekundärfarbe je nach Scheme
        return colorScheme == .dark
            ? Color.white.opacity(0.6)
            : Color.black.opacity(0.6)
    }

    func startPageRowBackground(isSelected: Bool) -> Color {
        isSelected
            ? accentColor.opacity(0.12)
            : .clear
    }
}
