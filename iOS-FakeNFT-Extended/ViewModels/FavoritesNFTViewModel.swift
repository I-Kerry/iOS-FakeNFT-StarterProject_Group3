import Foundation
import Observation

@MainActor
@Observable
final class FavoritesNFTViewModel {
    private let nftService: NftService
    private let profileService: ProfileService
    private let nftIDs: [String]
    private var likedNFTIDs: Set<String>
    private var profile: Profile?
    
    var nfts: [Nft] = []
    var isLoading = false
    var loadError: Error?
    var onProfileUpdated: ((Profile) -> Void)?
    
    init(
        nftService: NftService,
        profileService: ProfileService,
        profile: Profile?,
        onProfileUpdated: ((Profile) -> Void)? = nil,
        previewNFTs: [Nft] = []
    ) {
        self.nftService = nftService
        self.profileService = profileService
        self.profile = profile
        self.onProfileUpdated = onProfileUpdated
        self.nftIDs = profile?.likes ?? []
        self.nfts = previewNFTs
        self.likedNFTIDs = Set(profile?.likes ?? [])
    }
    
    func loadNFTs() async {
        isLoading = true
        defer { isLoading = false }
        
        for id in nftIDs {
            do {
                let nft = try await nftService.loadNft(id: id)
                nfts.append(nft)
            } catch {
                loadError = error
            }
        }
    }
    
    func toggleFavorite(for nft: Nft) async {
        if likedNFTIDs.contains(nft.id) {
            likedNFTIDs.remove(nft.id)
            nfts.removeAll { $0.id == nft.id }
        } else {
            likedNFTIDs.insert(nft.id)
        }
        
        await updateLikes()
    }
    
    func updateLikes() async {
        guard let currentProfile = profile else { return }
        
        do {
            let updatedProfile = try await profileService.updateProfile(
                name: currentProfile.name,
                description: currentProfile.description,
                avatar: currentProfile.avatar?.absoluteString ?? "",
                website: currentProfile.website.absoluteString,
                likes: Array(likedNFTIDs)
            )

            profile = updatedProfile
            onProfileUpdated?(updatedProfile)
        } catch {
            loadError = error
        }
    }
}
