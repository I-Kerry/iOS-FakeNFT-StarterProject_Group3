import Foundation

struct NFTCollection: Identifiable, Decodable, Sendable {
	let id: String
	let name: String
	let cover: String?
	let nfts: [String]?
	let description: String?
	let author: String?
	
	var nftCount: Int {
		nfts?.count ?? 0
	}
	
	var authorName: String {
		if let authorURLString = author,
		   let url = URL(string: authorURLString),
		   !url.lastPathComponent.isEmpty && url.lastPathComponent != "/" {
			return url.lastPathComponent.capitalized
		}
		return "Creator \(name)"
	}
}
