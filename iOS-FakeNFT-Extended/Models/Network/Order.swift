//
//  Order.swift
//  iOS-FakeNFT-Extended
//
//  Created by Kirill Maidanovich on 19.09.2026.
//

import Foundation

struct Order: Sendable, Decodable {
    var id: String
    let nfts: [String]
}
