import Foundation

protocol NftService: Sendable {
	func loadNft(id: String) async throws -> Nft
}

final class NftServiceImpl: NftService {
	private let actor: NftServiceActor
	
	init(networkClient: NetworkClient, storage: NftStorage) {
		self.actor = NftServiceActor(networkClient: networkClient, storage: storage)
	}
	
	func loadNft(id: String) async throws -> Nft {
		try await actor.loadNft(id: id)
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
}
