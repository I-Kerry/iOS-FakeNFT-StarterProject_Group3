//
//  CurrencyView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Kirill Maidanovich on 25.09.2026.
//

import SwiftUI

struct CurrencyPaymentView: View {
    
    @State private var viewModel: CurrencyViewModel
    @State private var showSuccess = false
    
    private let columns = [
        GridItem(.flexible() ,spacing: Constants.columnSpacing),
        GridItem(.flexible() ,spacing: Constants.columnSpacing)
    ]
    
    init(viewModel: CurrencyViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .idle, .loading:
                EmptyView()
            case .data:
                ScrollView {
                    LazyVGrid(columns: columns, alignment: .leading, spacing: Constants.vGridSpacing) {
                        ForEach(viewModel.currencies) { currency in
                            CurrencyItemView(currency: currency, isSelected: viewModel.selectedCurrencyID == currency.id)
                                .onTapGesture {
                                    viewModel.selectedCurrencyID = currency.id
                                }
                        }
                    }
                    .padding(Constants.padding)
                }
                .safeAreaInset(edge: .bottom) {
                    AgreementView(onPay: { Task { await viewModel.pay() } })
                }
            case .error(let error):
                Text(error.localizedDescription)
            }
            
        }
        .task {
            await viewModel.loadCurrencies()
        }
        .navigationTitle(Constants.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $viewModel.didPaySuccessfully) {
            PaymentSuccessView(backToCart: {
                viewModel.didPaySuccessfully = false
                viewModel.onCompletePayment()
            })
        }
    }
}

private enum Constants {
    static let columnSpacing: CGFloat = 7
    static let vGridSpacing: CGFloat = 7
    static let padding: CGFloat = 16
    
    static let navigationTitle = "Выберите способ оплаты"
}

#Preview {
    let vm: CurrencyViewModel = {
        let vm = CurrencyViewModel(
            service: MockCurrencyService(),
            onCompletePayment: {}
        )
        vm.currencies = MockCurrencyService.sampleCurrencies
        vm.state = .data
        return vm
    }()
    
    CurrencyPaymentView(viewModel: vm)
        .preferredColorScheme(.light)
}
