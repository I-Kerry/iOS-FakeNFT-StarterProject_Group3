import Foundation

struct Nft: Identifiable, Decodable, Sendable {
	let id: String
	let name: String
	let imageURLs: [URL]
	let rating: Int
	let price: Double
	let author: String
	let description: String
	
	enum CodingKeys: String, CodingKey {
		case id
		case name
		case imageURLs = "images"
		case rating
		case price
		case author
		case description
	}
}
