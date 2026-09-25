//
//  PayResult.swift
//  iOS-FakeNFT-Extended
//
//  Created by Kirill Maidanovich on 19.09.2026.
//

import Foundation

struct PayResult: Sendable, Decodable {
    var success: Bool
    var orderId: String
}
