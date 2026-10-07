import SwiftUI

struct FavoritesNFTView: View {
    private enum Constants {
        static let horizontalPadding: CGFloat = 16
        static let headerHeight: CGFloat = 42
        static let contentTopPadding: CGFloat = 20
        
        static let backIconSize: CGFloat = 20
        
        static let gridHorizontalSpacing: CGFloat = 7
        static let gridVerticalSpacing: CGFloat = 20
        
        static let zeroSpacing: CGFloat = 0
        
        static let gridColumns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    }
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel: FavoritesNFTViewModel
    
    init(viewModel: FavoritesNFTViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: Constants.zeroSpacing) {
            header
            
            ScrollView {
                if !viewModel.isLoading && viewModel.nfts.isEmpty {
                    Text("У Вас ещё нет избранных NFT")
                        .font(Font(UIFont.bodyBold))
                        .foregroundStyle(Color(uiColor: .yaBlackLight))
                        .frame(maxWidth: .infinity, minHeight: 600)
                } else {
                    LazyVGrid(
                        columns: Constants.gridColumns,
                        spacing: Constants.gridVerticalSpacing
                    ) {
                        ForEach(viewModel.nfts, id: \.id) { nft in
                            FavoriteNFTCardView(
                                nft: nft,
                                onFavoriteTapped: {
                                    Task {
                                        await viewModel.toggleFavorite(for: nft)
                                    }
                                }
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.top, Constants.contentTopPadding)
        }
        .background(.background)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .task {
            await viewModel.loadNFTs()
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.2)
            }
        }
        .alert(
            "Ошибка",
            isPresented: .constant(
                viewModel.loadError != nil || viewModel.saveError != nil
            )
        ) {
            Button("OK") {
                viewModel.loadError = nil
                viewModel.saveError = nil
            }
        } message: {
            Text(
                viewModel.saveError != nil
                ? "Не удалось сохранить изменения избранного"
                : "Не удалось загрузить избранные NFT"
            )
        }
    }
}

private extension FavoritesNFTView {
    var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(
                        .system(
                            size: Constants.backIconSize,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(Color(uiColor: .yaBlackLight))
            }
            
            if !viewModel.nfts.isEmpty {
                Spacer()
                
                Text("Избранные NFT")
                    .font(Font(UIFont.bodyBold))
                    .foregroundStyle(Color(uiColor: .yaBlackLight))
                
                Spacer()
                
                Color.clear
                    .frame(
                        width: Constants.backIconSize,
                        height: Constants.backIconSize
                    )
            }
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: Constants.headerHeight)
    }
}

#Preview("With NFT") {
    FavoritesNFTView(
        viewModel: FavoritesNFTViewModel(
            nftService: PreviewNftService(),
            profileService: PreviewProfileService(),
            profile: nil,
            previewNFTs: [
                Nft(
                    id: "1",
                    name: "Archie",
                    images: [],
                    rating: 1,
                    price: 1.78,
                    author: "John Doe"
                ),
                Nft(
                    id: "2",
                    name: "Pixi",
                    images: [],
                    rating: 3,
                    price: 1.78,
                    author: "John Doe"
                ),
                Nft(
                    id: "3",
                    name: "Melissa",
                    images: [],
                    rating: 5,
                    price: 1.78,
                    author: "John Doe"
                ),
                Nft(
                    id: "4",
                    name: "April",
                    images: [],
                    rating: 2,
                    price: 1.78,
                    author: "John Doe"
                ),
                Nft(
                    id: "5",
                    name: "Daisy",
                    images: [],
                    rating: 1,
                    price: 1.78,
                    author: "John Doe"
                ),
                Nft(
                    id: "6",
                    name: "Lilo",
                    images: [],
                    rating: 4,
                    price: 1.78,
                    author: "John Doe"
                )
            ]
        )
    )
}

#Preview("Empty") {
    FavoritesNFTView(
        viewModel: FavoritesNFTViewModel(
            nftService: PreviewNftService(),
            profileService: PreviewProfileService(),
            profile: nil,
            previewNFTs: []
        )
    )
}
