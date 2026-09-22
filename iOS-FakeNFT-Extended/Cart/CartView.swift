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
    
    init(viewModel: CartViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .idle, .loading:
                EmptyView()
            case .data:
                if viewModel.nfts.isEmpty {
                    Text("Корзина пуста")
                        .font(.bodyBold)
                        .foregroundStyle(.button)
                }
                List(viewModel.nfts) { nft in
                    CartItemView(nft: nft) {
                        Task {
                            await viewModel.removeItem(id: nft.id)
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                }
                .listStyle(.plain)

            case .error(let error):
                Text(error.localizedDescription)
            }
        }
        .safeAreaInset(edge: .bottom) {
            CartBottomView(
                nftAmount: viewModel.nfts.count,
                totalPrice: viewModel.totalPrice,
                onPay: viewModel.onPayScreen
            )
        }
        .task { await viewModel.loadCart() }
        .onChange(of: viewModel.state) { _, state in
            switch state {
            case .loading: ProgressHUD.animate()
            default: ProgressHUD.dismiss()
            }
        }
    }
}

#Preview("С товарами") {
    let vm = CartViewModel(cartService: MockCartService(), onPayScreen: {})
    vm.state = .data
    vm.nfts = MockCartService.sampleNfts
    return CartView(viewModel: vm)
        .preferredColorScheme(.light)
}

