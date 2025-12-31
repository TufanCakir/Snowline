//
//  BrowserUI.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

internal import Combine
import Foundation

@MainActor
final class BrowserUI: ObservableObject {

    static let shared = BrowserUI()

    @Published var showAddress = false
    @Published var showTabs = false
    @Published var showSettings = false
    @Published var privateMode = false

    func newTab() {
        showAddress = true
    }
}
