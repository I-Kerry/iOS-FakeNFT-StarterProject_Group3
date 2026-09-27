//
//  PaymentSuccessView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Kirill Maidanovich on 27.09.2026.
//

import SwiftUI

struct PaymentSuccessView: View {
    var backToCart: () -> Void
    
    var body: some View {
        
        VStack(alignment: .center, spacing: Constants.spacing) {
            Image(.paymentSuccess)
                .resizable()
                .frame(width: Constants.imageFrame, height: Constants.imageFrame)
            Text(Constants.paymentSuccess)
                .font(.headline3)
                .multilineTextAlignment(.center)
                .foregroundStyle(.button)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .bottom) {
            ReusableButton(title: Constants.backTitle) {
                backToCart()
            }
        }
    }
}

private enum Constants {
    static let spacing: CGFloat = 20
    static let imageFrame: CGFloat = 278
    
    static let paymentSuccess = "Успех! Оплата прошла,\nпоздравляем с покупкой!"
    static let backTitle = "Вернуться в корзину"
}

#Preview {
    PaymentSuccessView(backToCart: {})
}
