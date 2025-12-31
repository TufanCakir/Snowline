//
//  Tab.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import Foundation
internal import UIKit

struct Tab: Identifiable {
    let id = UUID()
    let url: URL
    let screenshot: UIImage?
}
