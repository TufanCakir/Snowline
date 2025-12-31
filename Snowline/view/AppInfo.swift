//
//  AppInfo.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import Foundation

enum AppInfo {
    static let version: String =
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        ?? "1.0"
    static let build: String =
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
}
