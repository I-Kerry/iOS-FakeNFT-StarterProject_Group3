import Foundation
import Observation

@MainActor
@Observable
final class MyNFTViewModel {
    
    enum SortType {
        case price
        case rating
        case name
    }
    
    private let nftService: NftService
    private let nftIDs: [String]

    var nfts: [Nft] = []
    var isLoading = false
    var loadError: Error?
    var sortType: SortType = .rating

    init(
        nftService: NftService,
        nftIDs: [String] = [],
        previewNFTs: [Nft] = []
    ) {
        self.nftService = nftService
        self.nftIDs = nftIDs
        self.nfts = previewNFTs
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
}
