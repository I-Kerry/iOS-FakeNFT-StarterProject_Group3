//
//  CartView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Kirill Maidanovich on 21.09.2026.
//

import SwiftUI
import ProgressHUD

struct CartView: View {
    @State private var viewModel: CartViewModel
    @State private var nftToDelete: Nft?
    @State private var showSortSheet = false
    
    init(viewModel: CartViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.state {
                case .idle, .loading:
                    EmptyView()
                case .data:
                    if viewModel.nfts.isEmpty {
                        Text(Constants.emptyCartTitle)
                            .font(.bodyBold)
                            .foregroundStyle(.button)
                    }
                    List(viewModel.nfts) { nft in
                        CartItemView(nft: nft) {
                            nftToDelete = nft
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                    }
                    .listStyle(.plain)
                    .safeAreaInset(edge: .bottom) {
                        CartBottomView(
                            nftAmount: viewModel.nfts.count,
                            totalPrice: viewModel.totalPrice,
                            onPay: { viewModel.onPayScreen() }
                        )
                    }
                case .error(let error):
                    Text(error.localizedDescription)
                }
            }
            .task { await viewModel.loadCart() }
            .onChange(of: viewModel.state) { _, state in
                switch state {
                case .loading: ProgressHUD.animate()
                default: ProgressHUD.dismiss()
                }
            }
            .blur(radius: nftToDelete != nil ? 10 : 0)
            .toolbar(nftToDelete != nil ? .hidden : .visible, for: .navigationBar)
            .toolbar(nftToDelete != nil ? .hidden : .visible, for: .tabBar)
            .overlay {
                if let nft = nftToDelete {
                    DeleteConfirmationView(
                        nft: nft,
                        onDelete: {
                            Task {
                                await viewModel.removeItem(id: nft.id)
                                nftToDelete = nil
                            }
                        },
                        onCancel: { nftToDelete = nil }
                    )
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)

            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSortSheet = true
                    } label: {
                        Image(.contextMenu)
                            .renderingMode(.template)
                            .foregroundStyle(.button)
                            .frame(width: Constants.imageWidth, height: Constants.imageHeight)
                    }
                    .frame(width: Constants.imageFrameSize, height: Constants.imageFrameSize)
                }
            }
            
            .confirmationDialog(Constants.contextMenuTitle, isPresented: $showSortSheet, titleVisibility: .visible) {
                Button(Constants.byName) { viewModel.sortNFTs(by: .byName) }
                Button(Constants.byRating) { viewModel.sortNFTs(by: .byRating) }
                Button(Constants.byPrice) { viewModel.sortNFTs(by: .byPrice) }
                Button(Constants.close, role: .cancel) {}
            }
            
        }
    }
}

private enum Constants {
    static let emptyCartTitle = "Корзина пуста"
    static let imageWidth: CGFloat = 21
    static let imageHeight: CGFloat = 12.6
    static let imageFrameSize: CGFloat = 42
    static let contextMenuTitle = "Сортировка"
    static let byName = "По названию"
    static let byRating = "По рейтингу"
    static let byPrice = "По цене"
    static let close = "Закрыть"
}

#Preview("Items") {
    let vm = CartViewModel(cartService: MockCartService(), onPayScreen: {})
    vm.state = .data
    vm.nfts = MockCartService.sampleNfts
    return CartView(viewModel: vm)
        .preferredColorScheme(.dark)
}

