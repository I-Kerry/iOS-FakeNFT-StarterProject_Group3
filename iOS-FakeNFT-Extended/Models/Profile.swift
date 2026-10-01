import Foundation

struct Profile: Decodable, Sendable {
    let name: String
    let avatar: URL?
    let description: String
    let website: URL
    let nfts: [String]
    let likes: [String]
    let id: String
}

extension Profile {
    enum CodingKeys: String, CodingKey {
        case name
        case avatar
        case description
        case website
        case nfts
        case likes
        case id
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)

        let avatarString = try container.decode(String.self, forKey: .avatar)
        avatar = URL(string: avatarString)

        description = try container.decode(String.self, forKey: .description)
        website = try container.decode(URL.self, forKey: .website)
        nfts = try container.decode([String].self, forKey: .nfts)
        likes = try container.decode([String].self, forKey: .likes)
        id = try container.decode(String.self, forKey: .id)
    }
}
