import Foundation

struct PreviewNftService: NftService {
    func loadNft(id: String) async throws -> Nft {
        fatalError("PreviewNftService is not used")
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
