//
//  TabRouter.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

internal import Combine
import Foundation

@MainActor
final class TabRouter: ObservableObject {

    static let shared = TabRouter()

    @Published var activeURL: URL? = nil
}
