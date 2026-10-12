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
                ProgressView()
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
                    AgreementView(
                        onPay: { Task { await viewModel.pay() } },
                        isEnabled: viewModel.selectedCurrencyID != nil && !viewModel.isPaying)
                }
            case .error(let error):
                Text(error.localizedDescription)
            }
            if viewModel.isPaying {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.gray.opacity(0.3))
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
        .alert(
            "",
            isPresented: Binding(
                get: { viewModel.paymentError != nil },
                set: { if !$0 { viewModel.paymentError = nil }})) {
                    
                        Button("Payment.cancel", role: .cancel, action: { viewModel.paymentError = nil })
                        Button("Payment.repeat", action: { Task { await viewModel.pay()}})
                    
                } message: {
                    Text("Cart.paymentFailedError")
                        .font(.bodyBold)
                }
    }
}

private enum Constants {
    static let columnSpacing: CGFloat = 7
    static let vGridSpacing: CGFloat = 7
    static let padding: CGFloat = 16
    
    static let navigationTitle = String(localized: "Payment.method")
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
