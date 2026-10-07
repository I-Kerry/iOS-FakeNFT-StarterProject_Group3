import Foundation
import Observation

@MainActor
@Observable
final class FavoritesNFTViewModel {
    private let nftService: NftService
    private let profileService: ProfileService
    private let nftIDs: [String]
    private var likedNFTIDs: Set<String>
    private var confirmedLikedNFTIDs: Set<String>
    private var profile: Profile?
    private var isUpdatingLikes = false
    private var needsLikesUpdate = false
    
    var nfts: [Nft] = []
    var isLoading = false
    var loadError: Error?
    var saveError: Error?
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
        self.confirmedLikedNFTIDs = Set(profile?.likes ?? [])
    }
    
    func loadNFTs() async {
        isLoading = true
        nfts = []
        loadError = nil
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
        } else {
            likedNFTIDs.insert(nft.id)
        }
        
        needsLikesUpdate = true
        
        guard !isUpdatingLikes else { return }
        
        await updateLikes()
    }
    
    func updateLikes() async {
        guard let currentProfile = profile else { return }
        
        isUpdatingLikes = true
        needsLikesUpdate = false
        
        defer {
            isUpdatingLikes = false
        }
        
        do {
            let updatedProfile = try await profileService.updateProfile(
                name: currentProfile.name,
                description: currentProfile.description,
                avatar: currentProfile.avatar?.absoluteString ?? "",
                website: currentProfile.website.absoluteString,
                likes: Array(likedNFTIDs)
            )
            
            profile = updatedProfile
            confirmedLikedNFTIDs = Set(updatedProfile.likes)
            nfts.removeAll { !updatedProfile.likes.contains($0.id) }
            onProfileUpdated?(updatedProfile)
        } catch {
            likedNFTIDs = confirmedLikedNFTIDs
            saveError = error
        }
        
        if needsLikesUpdate {
            await updateLikes()
        }
    }
}
