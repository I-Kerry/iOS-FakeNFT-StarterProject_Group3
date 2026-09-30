//
//  CartErrors.swift
//  iOS-FakeNFT-Extended
//
//  Created by Kirill Maidanovich on 01.10.2026.
//

import Foundation

enum CartErrors: LocalizedError {
    case paymentFailed
    
    var errorDescription: String? {
        switch self {
        case .paymentFailed: "Не удалось произвести оплату" }
    }
}
