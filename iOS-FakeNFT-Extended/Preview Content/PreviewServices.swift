import Foundation

struct PreviewNftService: NftService {
	func loadNft(id: String) async throws -> Nft {
		return Nft(
			id: id,
			name: "Preview NFT",
			imageURLs: [],
			rating: 4,
			price: 2.5,
			author: "John Doe",
			description: "Sample description"
		)
	}
	
	func loadCollections() async throws -> [NFTCollection] {
		return []
	}
	
	func loadOrder() async throws -> Order {
		return Order(id: "preview", nfts: [])
	}
	
	func updateOrder(nftIds: [String]) async throws -> Order {
		return Order(id: "preview", nfts: nftIds)
	}
}

struct PreviewProfileService: ProfileService {
	func loadProfile() async throws -> Profile {
		fatalError("PreviewProfileService is not used")
	}
	
	func updateProfile(
		name: String,
		description: String,
		avatar: String,
		website: String,
		likes: [String]
	) async throws -> Profile {
		fatalError("PreviewProfileService is not used")
	}
}
