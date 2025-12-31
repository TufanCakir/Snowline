//
//  Result.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import Foundation

struct Result: Identifiable {
    let id = UUID()
    let url: URL
    let title: String
    let snippet: String
    let score: Int
}
