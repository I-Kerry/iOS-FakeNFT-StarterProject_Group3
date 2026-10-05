import Foundation
import Observation

@MainActor
@Observable
final class MyNFTViewModel {
    private let nftService: NftService

    var nfts: [Nft] = []

    init(nftService: NftService) {
        self.nftService = nftService
    }

    init(nftService: NftService, previewNFTs: [Nft]) {
        self.nftService = nftService
        self.nfts = previewNFTs
    }
}
