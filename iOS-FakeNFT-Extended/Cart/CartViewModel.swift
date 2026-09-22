//
//  CartViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Kirill Maidanovich on 19.09.2026.
//

import Foundation

enum CartState: Equatable {
    case idle
    case loading
    case data
    case error(Error)
    
    static func == (lhs: CartState, rhs: CartState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.data, .data): true
        case (.error, .error): true
        default: false
        }
    }
}

@Observable
@MainActor
final class CartViewModel {
    private let cartService: CartService
    var nfts: [Nft] = []
    var state: CartState = .idle
    var totalPrice: Double {
        nfts.reduce(0) { $0 + $1.price }
    }
    
    var onPayScreen: () -> Void = {}
    
    init(cartService: CartService, onPayScreen: @escaping () -> Void) {
        self.cartService = cartService
        self.onPayScreen = onPayScreen
    }
    
    func loadCart() async {
        state = .loading
        do {
            nfts = try await cartService.loadCart()
            state = .data
        } catch {
            state = .error(error)
        }
    }
    
    func removeItem(id: String) async {
        do {
            try await cartService.removeItem(itemId: id)
            nfts.removeAll { $0.id == id }
        } catch {
            state = .error(error)
        }
    }
}
