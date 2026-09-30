//
//  CartBottomView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Kirill Maidanovich on 21.09.2026.
//

import SwiftUI

struct CartBottomView: View {
    let nftAmount: Int
    let totalPrice: Double
    let onPay: () -> Void
    var body: some View {
        HStack(spacing: Constants.sStackSpacing) {
            VStack(alignment: .leading, spacing: Constants.vStackSpacing) {
                Text("\(nftAmount) NFT")
                    .font(.caption1)
                    .foregroundStyle(.button)
                Text("\(totalPrice, specifier: "%.2f") ETH")
                    .font(.bodyBold)
                    .foregroundStyle(.greenCurrency)
            }
            payButton
        }
        .padding(Constants.padding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            UnevenRoundedRectangle(
                topLeadingRadius: Constants.trailingLeadingCornerRadius,
                topTrailingRadius: Constants.trailingLeadingCornerRadius
            )
            .fill(.graySecondaryBackground)
            .ignoresSafeArea(edges: .bottom)
        }
    }
    
    private var payButton: some View {
        Button(action: onPay) {
            Text(Constants.buttonTitle)
                .foregroundStyle(.textMain)
                .font(.bodyBold)
                .frame(width: Constants.buttonWidth, height: Constants.buttonHeight)
                .background(Color.button)
                .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        }
    }
}

private enum Constants {
    static let sStackSpacing: CGFloat = 24
    static let vStackSpacing: CGFloat = 2
    static let padding: CGFloat = 16
    static let trailingLeadingCornerRadius: CGFloat = 12
    static let buttonWidth: CGFloat = 240
    static let buttonHeight: CGFloat = 44
    static let cornerRadius: CGFloat = 16

    static let buttonTitle = "К оплате"
}

#Preview("light") {
    CartBottomView(nftAmount: 3, totalPrice: 8.56, onPay: {})
        .preferredColorScheme(.light)
}
#Preview("Dark") {
    CartBottomView(nftAmount: 3, totalPrice: 8.56, onPay: {})
        .preferredColorScheme(.dark)
}
