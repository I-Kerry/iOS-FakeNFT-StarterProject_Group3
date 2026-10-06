import Foundation
import Observation

@MainActor
@Observable
final class MyNFTViewModel {
    
    enum SortType: String {
        case price
        case rating
        case name
    }
    
    private let nftService: NftService
    private let nftIDs: [String]
    private var likedNFTIDs: Set<String> = []
    private let profileService: ProfileService
    private var profile: Profile?
    
    private enum Constants {
        static let sortTypeKey = "myNFTSortType"
    }
    
    var nfts: [Nft] = []
    var isLoading = false
    var loadError: Error?
    var onProfileUpdated: ((Profile) -> Void)?
    
    var sortType: SortType {
        didSet {
            UserDefaults.standard.set(
                sortType.rawValue,
                forKey: Constants.sortTypeKey
            )
        }
    }
    
    init(
        nftService: NftService,
        profileService: ProfileService,
        nftIDs: [String] = [],
        likedNFTIDs: Set<String> = [],
        profile: Profile? = nil,
        onProfileUpdated: ((Profile) -> Void)? = nil,
        previewNFTs: [Nft] = []
    ){
        self.nftService = nftService
        self.profileService = profileService
        self.nftIDs = nftIDs
        self.likedNFTIDs = likedNFTIDs
        self.profile = profile
        self.onProfileUpdated = onProfileUpdated
        self.nfts = previewNFTs
        
        let savedSortType = UserDefaults.standard.string(
            forKey: Constants.sortTypeKey
        )
        
        self.sortType = SortType(rawValue: savedSortType ?? "") ?? .rating
    }
    
    func sortNFTs() {
        switch sortType {
        case .price:
            nfts.sort { $0.price < $1.price }
            
        case .rating:
            nfts.sort { $0.rating > $1.rating }
            
        case .name:
            nfts.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }
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
        sortNFTs()
    }
    
    func isFavorite(_ nft: Nft) -> Bool {
        likedNFTIDs.contains(nft.id)
    }
    
    func toggleFavorite(for nft: Nft) async {
        if likedNFTIDs.contains(nft.id) {
            likedNFTIDs.remove(nft.id)
        } else {
            likedNFTIDs.insert(nft.id)
        }
        
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
