import Foundation
import Observation

@MainActor
@Observable
final class FavoritesNFTViewModel {
    var nfts: [Nft] = []

    init(previewNFTs: [Nft] = []) {
        self.nfts = previewNFTs
    }
}
