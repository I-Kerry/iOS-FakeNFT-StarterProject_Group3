//
//  CurrencyView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Kirill Maidanovich on 25.09.2026.
//

import SwiftUI

struct CurrencyPaymentView: View {
    @State private var  viewModel: CurrencyViewModel
    
    private let columns = [
        GridItem(.flexible() ,spacing: 7),
        GridItem(.flexible() ,spacing: 7)
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
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 7) {
                        ForEach(viewModel.currencies) { currency in
                            CurrencyItemView(currency: currency)
                        }
                    }
                    .padding(16)
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
        .navigationTitle("Выберите способ оплаты")
        .navigationBarTitleDisplayMode(.inline)
    }
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
