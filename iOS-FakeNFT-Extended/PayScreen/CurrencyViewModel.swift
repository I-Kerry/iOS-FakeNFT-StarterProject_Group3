//
//  CurrencyViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Kirill Maidanovich on 25.09.2026.
//

import Foundation

enum CurrencyState {
    case idle
    case loading
    case data
    case error(Error)
}

@Observable
@MainActor
final class CurrencyViewModel {
    private var service: CartService
    var currencies: [Currency] = []
    var state: CurrencyState = .idle
    var selectedCurrencyID: String? = nil
    var paymentError: Error? = nil
    
    var onCompletePayment: () -> Void
    
    init(service: CartService, onCompletePayment: @escaping () -> Void) {
        self.service = service
        self.onCompletePayment = onCompletePayment
    }
    
    func loadCurrencies() async {
        state = .loading
        do {
            currencies = try await service.loadCurrencies()
            state = .data
        } catch {
            state = .error(error)
        }
    }
    
    func pay() async {
        guard let currencyID = selectedCurrencyID else { return }
        
        do {
            let success = try await service.pay(currencyId: currencyID)
            if success {
                onCompletePayment()
            } else {
                paymentError 
            }
        } catch {
            paymentError = error
        }
    }
}
