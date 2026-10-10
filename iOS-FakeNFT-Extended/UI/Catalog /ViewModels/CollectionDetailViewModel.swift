import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class CollectionDetailViewModel {
	private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Catalog", category: "CollectionDetail")
	private(set) var nfts: [String: Nft] = [:]
	var isLoading: Bool = false
	
	var likedNftIds: Set<String> = []
	var cartNftIds: Set<String> = []
	
	private let service: NftService
	
	init(service: NftService) {
		self.service = service
	}
	
	func loadNfts(ids: [String]) {
		guard !ids.isEmpty else { return }
		isLoading = true
		
		Task {
			await withTaskGroup(of: (String, Nft?).self) { group in
				for id in ids {
					guard nfts[id] == nil else { continue }
					
					group.addTask {
						do {
							let nft = try await self.service.loadNft(id: id)
							return (id, nft)
						} catch {
							self.logger.error("Ошибка загрузки отдельного NFT \(id): \(error.localizedDescription)")
							return (id, nil)
						}
					}
				}
				
				for await (id, nft) in group {
					if let nft = nft {
						self.nfts[id] = nft
					}
				}
			}
			isLoading = false
		}
	}
	
	func isLiked(nftId: String) -> Bool {
		likedNftIds.contains(nftId)
	}
	
	func toggleLike(for nftId: String) {
		if likedNftIds.contains(nftId) {
			likedNftIds.remove(nftId)
		} else {
			likedNftIds.insert(nftId)
		}
	}
	
	func isInCart(nftId: String) -> Bool {
		cartNftIds.contains(nftId)
	}
	
	func toggleCart(for nftId: String) {
		if cartNftIds.contains(nftId) {
			cartNftIds.remove(nftId)
		} else {
			cartNftIds.insert(nftId)
		}
	}
}
