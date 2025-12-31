//
//  Trust.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import Foundation

func isTrusted(_ url: URL) -> Bool {
    let trusted = ["wikipedia.org", "apple.com", "github.com", "bbc.com"]
    return trusted.contains { url.host?.contains($0) == true }
}
