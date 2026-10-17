import Foundation

struct Order: Sendable, Decodable {
    var id: String
    let nfts: [String]
}
