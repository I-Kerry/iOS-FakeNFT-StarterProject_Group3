import SwiftUI

struct MyNFTView: View {
    
    private enum Constants {
        static let horizontalPadding: CGFloat = 16
        static let headerHeight: CGFloat = 42
        
        static let backIconSize: CGFloat = 20
        static let sortIconSize: CGFloat = 24
        
        static let rowSpacing: CGFloat = 32
        static let contentTopPadding: CGFloat = 16
        static let zeroSpacing: CGFloat = 0
    }
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel: MyNFTViewModel
    @State private var isSortDialogPresented = false
    
    init(viewModel: MyNFTViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: Constants.zeroSpacing) {
            header
            
            List {
                if !viewModel.isLoading && viewModel.nfts.isEmpty {
                    Text(NSLocalizedString("NFT.myEmpty", comment: ""))
                        .font(.bodyBold)
                        .foregroundStyle(Color(uiColor: .yaBlackLight))
                        .frame(maxWidth: .infinity, minHeight: 600)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                } else {
                    ForEach(viewModel.nfts, id: \.id) { nft in
                        NFTRowView(nft: nft)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(
                                EdgeInsets(
                                    top: Constants.rowSpacing / 2,
                                    leading: Constants.horizontalPadding,
                                    bottom: Constants.rowSpacing / 2,
                                    trailing: Constants.horizontalPadding
                                )
                            )
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .padding(.top, Constants.contentTopPadding)
        }
        .background(.background)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.2)
            }
        }
        .alert(
            NSLocalizedString("Error.title", comment: ""),
            isPresented: .constant(viewModel.loadError != nil)
        ) {
            Button(NSLocalizedString("Common.ok", comment: "")) {
                viewModel.loadError = nil
            }
        } message: {
            Text(NSLocalizedString("NFT.loadError", comment: ""))
        }
        .task {
            await viewModel.loadNFTs()
        }
        .confirmationDialog(
            NSLocalizedString("NFT.sorting", comment: ""),
            isPresented: $isSortDialogPresented,
            titleVisibility: .visible
        ) {
            Button(NSLocalizedString("NFT.byPrice", comment: "")) {
                viewModel.sortType = .price
            }
            
            Button(NSLocalizedString("NFT.byRating", comment: "")) {
                viewModel.sortType = .rating
            }
            
            Button(NSLocalizedString("NFT.byName", comment: "")) {
                viewModel.sortType = .name
            }
            
            Button(
                NSLocalizedString("NFT.close", comment: ""),
                role: .cancel
            ) {}
        }
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
            
            if !viewModel.nfts.isEmpty {
                Spacer()
                
                Text(NSLocalizedString("Profile.myNFT", comment: ""))
                    .font(.bodyBold)
                    .foregroundStyle(Color(uiColor: .yaBlackLight))
                
                Spacer()
                
                Button {
                    isSortDialogPresented = true
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.system(
                            size: Constants.sortIconSize,
                            weight: .medium
                        ))
                        .foregroundStyle(Color(uiColor: .yaBlackLight))
                }
            }
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: Constants.headerHeight)
    }
}

#Preview("With NFT") {
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

#Preview("Empty") {
    MyNFTView(
        viewModel: MyNFTViewModel(
            nftService: PreviewNftService(),
            previewNFTs: []
        )
    )
}

