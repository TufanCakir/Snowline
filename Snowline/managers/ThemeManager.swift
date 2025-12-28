//
//  ThemeManager.swift
//  Snowline
//
//  Created by Tufan Cakir on 27.12.25.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class ThemeManager: ObservableObject {

    enum Mode: String, CaseIterable {
        case system, light, dark
    }

    @AppStorage("snowline_theme") var stored: Mode = .system
    @Published var current: Mode = .system

    init() {
        current = stored
    }

    func apply(_ mode: Mode) {
        stored = mode
        current = mode
    }

    var colorScheme: ColorScheme? {
        switch current {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}
