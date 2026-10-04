import Foundation
import Observation

@Observable
@MainActor
final class CollectionDetailViewModel {
	var likedNftIds: Set<String> = []
	var cartNftIds: Set<String> = []
	
	init() {}
	
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
