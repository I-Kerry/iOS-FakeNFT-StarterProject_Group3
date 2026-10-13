import Foundation

struct Currency: Sendable, Decodable, Identifiable {
    var id: String
    let title: String
    let name: String
    let image: URL?
}
