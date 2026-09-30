//
//  CurrencyItemView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Kirill Maidanovich on 26.09.2026.
//

import SwiftUI

struct CurrencyItemView: View {
    private let currency: Currency
    
    var isSelected: Bool
    
    init(currency: Currency, isSelected: Bool) {
        self.currency = currency
        self.isSelected = isSelected
    }
    
    var body: some View {
        HStack(spacing: Constants.hStackSpacing) {
            ZStack {
                Color.iconBackground
                    .frame(width: Constants.iconBackgroundFrame, height: Constants.iconBackgroundFrame)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadiusSmall))
                AsyncImage(url: currency.image) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: Constants.imageFrame, height: Constants.imageFrame)
                            .clipShape(Circle())
                    default:
                        EmptyView()
                    }
                }
            }
            VStack(alignment: .leading, spacing: Constants.zeroSpacing) {
                Group {
                    Text(currency.title)
                        .foregroundStyle(.button)
                    Text(currency.name)
                        .foregroundStyle(.greenCurrency)
                }
                .font(.caption2)
            }
            Spacer()
            
        }
        .padding(.leading, Constants.leadingPadding)
        .padding(.vertical, Constants.verticalPadding)
        .background(.graySecondaryBackground)
        .frame(width: Constants.itemViewWidth, height: Constants.itemViewHeight)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadiusBig))
        .overlay(
            RoundedRectangle(cornerRadius: Constants.cornerRadiusBig)
                .stroke(isSelected ? .button : .clear, lineWidth: Constants.strokeLineWidth)
        )
    }
}

private enum Constants {
    static let hStackSpacing: CGFloat = 4
    static let iconBackgroundFrame: CGFloat = 36
    static let cornerRadiusSmall: CGFloat = 6
    static let cornerRadiusBig: CGFloat = 12
    static let imageFrame: CGFloat = 31.5
    static let zeroSpacing: CGFloat = 0
    static let leadingPadding: CGFloat = 12
    static let verticalPadding: CGFloat = 8
    static let itemViewWidth: CGFloat = 168
    static let itemViewHeight: CGFloat = 46
    static let strokeLineWidth: CGFloat = 1
}

#Preview {
    CurrencyItemView(currency: Currency(id: "1", title: "MAIN", name: "USD", image: URL(string: "https://picsum.photos/400/400?random=2")!), isSelected: true)
}
