//
//  CartView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Kirill Maidanovich on 21.09.2026.
//

import SwiftUI

struct CartView: View {
    @State private var viewModel: CartViewModel
    @State private var nftToDelete: Nft?
    @State private var showSortSheet = false
    @State private var showCurrencyView = false
    
    init(viewModel: CartViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.state {
                case .idle, .loading:
                    ProgressView()
                case .data:
                    if viewModel.nfts.isEmpty {
                        Text(Constants.emptyCartTitle)
                            .font(.bodyBold)
                            .foregroundStyle(.button)
                    } else {
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
                                onPay: { showCurrencyView = true }
                            )
                            .navigationDestination(isPresented: $showCurrencyView) {
                                CurrencyPaymentView(viewModel: viewModel.makeCurrencyViewModel(onCompletePayment: {
                                    showCurrencyView = false
                                    viewModel.clearCart()
                                }))
                            }
                        }
                    }
                case .error(let error):
                    Text(error.localizedDescription)
                }
            }
            .task { await viewModel.loadCart() }
            .blur(radius: nftToDelete != nil ? 10 : 0)
            .toolbar(nftToDelete != nil ? .hidden : .visible, for: .navigationBar)
            .toolbar(nftToDelete != nil || showCurrencyView ? .hidden : .visible, for: .tabBar)
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
                if !viewModel.nfts.isEmpty {
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
    static let imageWidth: CGFloat = 21
    static let imageHeight: CGFloat = 12.6
    static let imageFrameSize: CGFloat = 42
    
    static let emptyCartTitle = String(localized: "Cart.isEmpty")
    static let contextMenuTitle = String(localized: "Cart.sort")
    static let byName = String(localized: "Cart.byName")
    static let byRating = String(localized: "Cart.byRating")
    static let byPrice = String(localized: "Cart.byPrice")
    static let close = String(localized: "Cart.close")
}

#Preview("Items") {
    let vm = CartViewModel(cartService: MockCartService())
    vm.state = .data
    vm.nfts = MockCartService.sampleNfts
    return CartView(viewModel: vm)
        .preferredColorScheme(.dark)
}
#Preview("Empty") {
    let vm = CartViewModel(cartService: MockCartService(nfts: []))
    vm.state = .data
    vm.nfts = []
    return CartView(viewModel: vm)
        .preferredColorScheme(.light)
}
