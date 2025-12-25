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

    private var resolvedScheme: ColorScheme {
        if let scheme = colorScheme {
            return scheme
        }

        let style = UITraitCollection.current.userInterfaceStyle
        return style == .dark ? .dark : .light
    }

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
        let hex = selectedTheme.accentColor.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        if !hex.isEmpty, selectedTheme.id != "system" {
            return Color(hex: hex)
        }

        return resolvedScheme == .dark ? Color.white : Color.accentColor
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
        let hex = selectedTheme.accentColor.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        if !hex.isEmpty, selectedTheme.id != "system" {
            return Color(hex: hex)
        }

        return resolvedScheme == .dark ? .white : .black
    }

    var toolbarSecondaryIconColor: Color {
        resolvedScheme == .dark
            ? Color.white.opacity(0.55)
            : Color.black.opacity(0.55)
    }
}

extension ThemeManager {

    func startPageIconColor(isSelected: Bool) -> Color {
        if isSelected {
            return accentColor
        }

        return resolvedScheme == .dark
            ? Color.white.opacity(0.65)
            : Color.black.opacity(0.65)
    }

    func startPageRowBackground(isSelected: Bool) -> Color {
        if isSelected {
            return accentColor.opacity(resolvedScheme == .dark ? 0.18 : 0.12)
        }
        return .clear
    }
}
