import Foundation

protocol NftService: Sendable {
	func loadNft(id: String) async throws -> Nft
	func loadCollections() async throws -> [NFTCollection]
}

final class NftServiceImpl: NftService {
	private let actor: NftServiceActor
	
	init(networkClient: NetworkClient, storage: NftStorage) {
		self.actor = NftServiceActor(networkClient: networkClient, storage: storage)
	}
	
	func loadNft(id: String) async throws -> Nft {
		try await actor.loadNft(id: id)
	}
	
	func loadCollections() async throws -> [NFTCollection] {
		try await actor.loadCollections()
	}
}

private actor NftServiceActor {
	private let networkClient: NetworkClient
	private let storage: NftStorage
	
	init(networkClient: NetworkClient, storage: NftStorage) {
		self.storage = storage
		self.networkClient = networkClient
	}
	
	func loadNft(id: String) async throws -> Nft {
		if let nft = await storage.getNft(with: id) {
			return nft
		}
		
		let request = NFTRequest(id: id)
		let nft: Nft = try await networkClient.send(request: request)
		await storage.saveNft(nft)
		return nft
	}
	
	func loadCollections() async throws -> [NFTCollection] {
		let request = CatalogRequest()
		let collections: [NFTCollection] = try await networkClient.send(request: request)
		return collections
	}
}
