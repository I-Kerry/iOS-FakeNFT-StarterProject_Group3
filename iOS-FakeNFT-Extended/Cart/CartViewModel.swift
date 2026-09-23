//
//  CartViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Kirill Maidanovich on 19.09.2026.
//

import SwiftUI

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

enum SortOption: String {
    case byPrice
    case byRating
    case byName
}

@Observable
@MainActor
final class CartViewModel {
    private let cartService: CartService
    var nfts: [Nft] = []
    var state: CartState = .idle
    var sortOption: SortOption {
        get {
            let raw = UserDefaults.standard.string(forKey: "cartSort") ?? "byName"
            return SortOption(rawValue: raw) ?? .byName
        }
        
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "cartSort")
        }
    }
    
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
            sortNFTs(by: sortOption)
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
    
    func sortNFTs(by option: SortOption) {
        sortOption = option
        switch option {
        case .byPrice:
            nfts.sort { $0.price < $1.price }
        case .byRating:
            nfts.sort { $0.rating < $1.rating }
        case .byName:
            nfts.sort { $0.name < $1.name }
        }
    }
}
