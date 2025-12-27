//
//  BrowserTab.swift
//  Snowline
//
//  Created by Tufan Cakir on 27.12.25.
//

import Combine
import Foundation
import UIKit

final class BrowserTab: ObservableObject, Identifiable {

    let id = UUID()
    let engine = WebEngine()

    @Published var snapshot: UIImage?

    init() {
        engine.onSnapshot = { [weak self] image in
            DispatchQueue.main.async {
                self?.snapshot = image
            }
        }
    }
}
