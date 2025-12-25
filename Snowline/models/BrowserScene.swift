//
//  BrowserScene.swift
//  Snowline
//
//  Created by Tufan Cakir on 25.12.25.
//
import Foundation

enum BrowserScene: String, Hashable, CaseIterable, Identifiable {
    case start, web, favorites, tabs, menu
    var id: String { rawValue }
}
