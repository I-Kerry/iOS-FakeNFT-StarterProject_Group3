import SwiftUI

struct MyNFTView: View {
    
    private enum Constants {
        static let horizontalPadding: CGFloat = 16
        static let headerHeight: CGFloat = 42
        
        static let backIconSize: CGFloat = 20
        static let sortIconSize: CGFloat = 24
        
        static let rowSpacing: CGFloat = 16
    }
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel: MyNFTViewModel
    
    init(viewModel: MyNFTViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header
            
            ScrollView {
                VStack(spacing: Constants.rowSpacing) {
                    ForEach(viewModel.nfts, id: \.id) { nft in
                        NFTRowView(nft: nft)
                    }
                }
                .padding(.horizontal, Constants.horizontalPadding)
            }
        }
        .background(.background)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
    }
}

private extension MyNFTView {
    var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(
                        size: Constants.backIconSize,
                        weight: .medium
                    ))
                    .foregroundStyle(Color(uiColor: .yaBlackLight))
            }

            Spacer()

            Text("Мои NFT")
                .font(Font(UIFont.bodyBold))
                .foregroundStyle(Color(uiColor: .yaBlackLight))

            Spacer()

            Button {
                // Сортировка будет добавлена в задаче 3.3
            } label: {
                Image(systemName: "line.3.horizontal.decrease")
                    .font(.system(
                        size: Constants.sortIconSize,
                        weight: .medium
                    ))
                    .foregroundStyle(Color(uiColor: .yaBlackLight))
            }
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .frame(height: Constants.headerHeight)
    }
}

#Preview {
    MyNFTView(
        viewModel: MyNFTViewModel(
            nftService: PreviewNftService(),
            previewNFTs: [
                Nft(
                    id: "1",
                    name: "Lilo",
                    images: [],
                    rating: 3,
                    price: 1.78,
                    author: "John Doe"
                ),
                Nft(
                    id: "2",
                    name: "Bear",
                    images: [],
                    rating: 5,
                    price: 2.45,
                    author: "Jane Doe"
                ),
                Nft(
                    id: "3",
                    name: "Cat",
                    images: [],
                    rating: 4,
                    price: 0.95,
                    author: "Alex"
                )
            ]
        )
    )
}


private struct PreviewNftService: NftService {
    func loadNft(id: String) async throws -> Nft {
        fatalError("PreviewNftService is not used")
    }
}
