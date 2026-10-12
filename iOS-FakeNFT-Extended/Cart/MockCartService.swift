//
//  MockCartService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Kirill Maidanovich on 22.09.2026.
//

import Foundation

final class MockCartService: CartService {
    var nfts: [Nft]
    var currencies: [Currency] = []
    var payResult: Bool = true
    var shouldThrow: Bool = false
    
    init(nfts: [Nft] = MockCartService.sampleNfts, shouldThrow: Bool = false) {
        self.nfts = nfts
        self.shouldThrow = shouldThrow
    }
    
    func loadCart() async throws -> [Nft] {
        if shouldThrow { throw URLError(.notConnectedToInternet) }
        return nfts
    }
    
    func loadCurrencies() async throws -> [Currency] {
        if shouldThrow { throw URLError(.notConnectedToInternet) }
        return currencies
    }
    
    func pay(currencyId: String) async throws -> Bool {
        if shouldThrow { throw URLError(.notConnectedToInternet) }
        return payResult
    }
    
    func removeItem(itemId: String) async throws {
        if shouldThrow { throw URLError(.notConnectedToInternet) }
        nfts.removeAll { $0.id == itemId }
    }
    
    static let sampleNfts: [Nft] = [
        Nft(
            id: "1",
            name: "NFT 1",
            images: [URL(string: "https://picsum.photos/400/400?random=1")!],
            rating: 5,
            price: 1.5,
            author: "Автор 1"
        ),
        Nft(
            id: "2",
            name: "NFT 2",
            images: [URL(string: "https://picsum.photos/400/400?random=2")!],
            rating: 4,
            price: 2.5,
            author: "Автор 2"
        ),
        Nft(
            id: "3",
            name: "NFT 3",
            images: [URL(string: "https://picsum.photos/400/400?random=3")!],
            rating: 3,
            price: 0.75,
            author: "Автор 3"
        )
    ]
}
