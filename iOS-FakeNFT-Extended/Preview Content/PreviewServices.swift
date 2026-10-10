import Foundation

struct PreviewNftService: NftService {
	// 1. Метод загрузки отдельного NFT (он нужен для карточек)
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
	
	// 2. Метод загрузки коллекций (нужен для вашего каталога)
	func loadCollections() async throws -> [NFTCollection] {
		return []
	}
	
	// 3. Заглушки для методов корзины, которые требуют протокол, но без использования типа Order 
	func loadOrder() async throws -> Any {
		fatalError("Preview mode: loadOrder is not implemented")
	}
	
	func updateOrder(nftIds: [String]) async throws -> Any {
		fatalError("Preview mode: updateOrder is not implemented")
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
