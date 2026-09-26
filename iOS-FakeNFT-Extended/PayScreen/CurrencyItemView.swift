//
//  CurrencyItemView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Kirill Maidanovich on 26.09.2026.
//

import SwiftUI

struct CurrencyItemView: View {
    private let currency: Currency
    
    init(currency: Currency) {
        self.currency = currency
    }
    
    var body: some View {
        HStack(spacing: 4) {
            ZStack {
                Color.iconBackground
                    .frame(width: 36, height: 36)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                AsyncImage(url: currency.image) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 31.5, height: 31.5)
                            .clipShape(Circle())
                    default:
                        EmptyView()
                    }
                }
            }
            VStack(alignment: .leading, spacing: 0) {
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
        .padding(.leading, 12)
        .padding(.vertical, 5)
        .background(.graySecondaryBackground)
        .frame(width: 168, height: 46)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    CurrencyItemView(currency: Currency(id: "1", title: "MAIN", name: "USD", image: URL(string: "https://picsum.photos/400/400?random=2")!))
}
