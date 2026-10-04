import Foundation

struct Nft: Identifiable, Decodable, Sendable {
	let id: String
	let name: String
	let images: [URL]
	let rating: Int
	let price: Double
	let author: String
	let description: String
}
