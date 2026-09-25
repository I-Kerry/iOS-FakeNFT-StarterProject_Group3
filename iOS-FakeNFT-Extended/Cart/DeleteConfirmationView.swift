//
//  DeleteConfirmationView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Kirill Maidanovich on 23.09.2026.
//

import SwiftUI

struct DeleteConfirmationView: View {
    let nft: Nft
    
    var onDelete: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        VStack(alignment: .center) {
            AsyncImage(url: nft.images.first) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                default: Color.gray.opacity(Constants.opacity)
                }
            }
            .frame(width: Constants.imageSize, height: Constants.imageSize)
            .aspectRatio(contentMode: .fill)
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
            
            Text(Constants.title)
                .font(.caption2)
                .foregroundStyle(.button)
                .padding(.top, Constants.smallPadding)
                .multilineTextAlignment(.center)
            HStack(alignment: .center, spacing: Constants.spacing) {
                Group {
                    Button(action: onDelete) {
                        Text(Constants.delete)
                        }
                    .foregroundStyle(.destract)
                    
                    Button(action: onCancel) {
                        Text(Constants.cancel)
                        }
                    .foregroundStyle(.textMain)
                }
                .font(.bodyRegular)
                .frame(width: Constants.buttonWidth, height: Constants.buttonHeight)
                .background(.button)
                .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
            }
            .padding(.top, Constants.bigPadding)
        }
    }
}

private enum Constants {
    static let opacity = 0.2
    static let imageSize: CGFloat = 108
    static let cornerRadius: CGFloat = 12
    static let smallPadding: CGFloat = 12
    static let spacing: CGFloat = 8
    static let buttonWidth: CGFloat = 127
    static let buttonHeight: CGFloat = 44
    static let bigPadding: CGFloat = 20
    
    static let title = "Вы уверены, что хотите\nудалить объект из корзины?"
    static let delete = "Удалить"
    static let cancel = "Вернуться"
}

#Preview {
    DeleteConfirmationView(nft: Nft(
        id: "1",
        name: "NFT 1",
        images: [URL(string: "https://picsum.photos/400/400?random=1")!],
        rating: 5,
        price: 1.5,
        author: "Автор 1"
    ), onDelete: {}, onCancel: {})
    .preferredColorScheme(.light)
}
