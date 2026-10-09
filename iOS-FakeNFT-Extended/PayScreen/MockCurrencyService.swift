//
//  MockCurrencyService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Kirill Maidanovich on 26.09.2026.
//

import Foundation

final class MockCurrencyService: CartService {
    var currencies: [Currency]
    var shouldThrow: Bool
    var payResult: Bool

    init(
        currencies: [Currency] = MockCurrencyService.sampleCurrencies,
        shouldThrow: Bool = false,
        payResult: Bool = true
    ) {
        self.currencies = currencies
        self.shouldThrow = shouldThrow
        self.payResult = payResult
    }
    
    func loadCart() async throws -> [Nft] {
        if shouldThrow { throw URLError(.notConnectedToInternet) }
        return []
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
    }
    
    static let sampleCurrencies: [Currency] = [
        Currency(
            id: "1",
            title: "Bitcoin",
            name: "BTC",
            image: URL(string: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png")
        ),
        Currency(
            id: "2",
            title: "Ethereum",
            name: "ETH",
            image: URL(string: "https://assets.coingecko.com/coins/images/279/large/ethereum.png")
        ),
        Currency(
            id: "3",
            title: "Tether",
            name: "USDT",
            image: URL(string: "https://assets.coingecko.com/coins/images/325/large/Tether.png")
        ),
        Currency(
            id: "4",
            title: "Solana",
            name: "SOL",
            image: URL(string: "https://assets.coingecko.com/coins/images/4128/large/solana.png")
        ),
        Currency(
            id: "5",
            title: "Dogecoin",
            name: "DOGE",
            image: URL(string: "https://assets.coingecko.com/coins/images/5/large/dogecoin.png")
        ),
        Currency(
            id: "6",
            title: "Cardano",
            name: "ADA",
            image: URL(string: "https://assets.coingecko.com/coins/images/975/large/cardano.png")
        )
    ]
}
