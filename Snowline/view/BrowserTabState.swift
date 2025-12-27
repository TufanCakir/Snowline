//
//  BrowserTabState.swift
//  Snowline
//
//  Created by Tufan Cakir on 27.12.25.
//

import Foundation
import SwiftUI

struct BrowserTabState: Codable, Identifiable {
    let id: UUID
    let url: String
}
