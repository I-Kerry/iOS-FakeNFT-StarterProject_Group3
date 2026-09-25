//
//  CartService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Kirill Maidanovich on 19.09.2026.
//

import Foundation

protocol CartService {
    func loadCart() async throws -> [Nft]
    func loadCurrencies() async throws -> [Currency]
    func pay(currencyId: String) async throws -> Bool
    func removeItem(itemId: String) async throws
}

actor CartServiceImpl: CartService {
    private let networkClient: NetworkClient
    private let nftService: NftService
    
    init(networkClient: NetworkClient, nftService: NftService) {
        self.networkClient = networkClient
        self.nftService = nftService
    }
    
    func loadCart() async throws -> [Nft] {
        let order: Order = try await networkClient.send(request: CartRequest.order)
        return try await withThrowingTaskGroup(of: Nft.self) { group in
            for id in order.nfts {
                group.addTask {
                    try await self.nftService.loadNft(id: id)
                }
            }
            return try await group.reduce(into: []) { $0.append($1) }
        }
    }
    
    func loadCurrencies() async throws -> [Currency] {
        try await networkClient.send(request: CartRequest.currencies)
    }
    
    func pay(currencyId: String) async throws -> Bool {
        let result: PayResult = try await networkClient.send(request: CartRequest.pay(currencyId: currencyId))
        if result.success {
            let _: Data = try await networkClient.send(request: CartRequest.updateOrder(nftIds: []))
        }
        return result.success
    }
    
    func removeItem(itemId: String) async throws {
        let order: Order = try await networkClient.send(request: CartRequest.order)
        let updated = order.nfts.filter { $0 != itemId }
        let _: Data = try await networkClient.send(request: CartRequest.updateOrder(nftIds: updated))
    }
    
    
}
