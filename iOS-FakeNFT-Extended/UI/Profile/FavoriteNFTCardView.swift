import SwiftUI

struct FavoriteNFTCardView: View {
    private enum Constants {
        static let imageSize: CGFloat = 80
        static let cornerRadius: CGFloat = 12
        
        static let imageToInfoSpacing: CGFloat = 12
        static let infoSpacing: CGFloat = 4
        static let ratingToPriceSpacing: CGFloat = 8
        
        static let heartSize: CGFloat = 21
        static let heartTopPadding: CGFloat = 6
        static let heartTrailingPadding: CGFloat = 4
        
        static let starSize: CGFloat = 12
        static let ratingSpacing: CGFloat = 2
        
        static let priceSpacing: CGFloat = 4
    }
    
    let nft: Nft
    let onFavoriteTapped: () -> Void
    
    var body: some View {
        HStack(
            alignment: .top,
            spacing: Constants.imageToInfoSpacing
        ) {
            nftImage
            
            VStack(alignment: .leading, spacing: Constants.infoSpacing) {
                Text(nft.name)
                    .font(.bodyBold)
                    .lineLimit(2)
                
                rating
                    .padding(.bottom, Constants.ratingToPriceSpacing)
                
                Text("\(nft.price, specifier: "%.2f") ETH")
                    .font(.bodyRegular)
                    .lineLimit(1)
                    .fixedSize()
            }
        }
    }
}

private extension FavoriteNFTCardView {
    var nftImage: some View {
        ZStack(alignment: .topTrailing) {
            AsyncImage(url: nft.images.first) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                    
                case .failure:
                    Color.gray
                    
                case .empty:
                    ProgressView()
                    
                @unknown default:
                    Color.gray
                }
            }
            .frame(
                width: Constants.imageSize,
                height: Constants.imageSize
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: Constants.cornerRadius
                )
            )
            
            Button(action: onFavoriteTapped) {
                Image(systemName: "heart.fill")
                    .font(.system(size: Constants.heartSize))
                    .foregroundStyle(Color(uiColor: .redUniversal))
                    .padding(.top, Constants.heartTopPadding)
                    .padding(.trailing, Constants.heartTrailingPadding)
            }        }
    }
    
    var rating: some View {
        HStack(spacing: Constants.ratingSpacing) {
            ForEach(0..<5, id: \.self) { index in
                Image(
                    systemName: index < nft.rating
                    ? "star.fill"
                    : "star"
                )
                .font(.system(size: Constants.starSize))
                .foregroundStyle(
                    index < nft.rating
                    ? .yellow
                    : .gray
                )
            }
        }
    }
}

#Preview {
    FavoriteNFTCardView(
        nft: Nft(
            id: "1",
            name: "Lilo",
            images: [],
            rating: 4,
            price: 1.78,
            author: "John Doe"
        ),
        onFavoriteTapped: {}
    )
    .padding()
}
