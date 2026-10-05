import Foundation
import Observation

@MainActor
@Observable
final class MyNFTViewModel {
    private let nftService: NftService
    private let nftIDs: [String]

    var nfts: [Nft] = []
    var isLoading = false
    var loadError: Error?

    init(
        nftService: NftService,
        nftIDs: [String] = [],
        previewNFTs: [Nft] = []
    ) {
        self.nftService = nftService
        self.nftIDs = nftIDs
        self.nfts = previewNFTs
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
}
