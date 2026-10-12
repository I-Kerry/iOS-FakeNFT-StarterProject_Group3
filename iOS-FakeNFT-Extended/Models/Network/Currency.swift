//
//  Currency.swift
//  iOS-FakeNFT-Extended
//
//  Created by Kirill Maidanovich on 19.09.2026.
//

import Foundation

struct Currency: Sendable, Decodable, Identifiable {
    var id: String
    let title: String
    let name: String
    let image: URL?
}
