import SwiftUI

struct NFTRowView: View {
    private enum Constants {
        static let imageSize: CGFloat = 108
        static let cornerRadius: CGFloat = 12
        static let imageToInfoSpacing: CGFloat = 20
        static let infoSpacing: CGFloat = 4
        static let authorSpacing: CGFloat = 3
        static let priceSpacing: CGFloat = 2
        static let starSize: CGFloat = 12
        static let ratingSpacing: CGFloat = 2
        static let heartSize: CGFloat = 18
        static let heartPadding: CGFloat = 12
        static let priceTrailingPadding: CGFloat = 39
    }

    let nft: Nft

    var body: some View {
        HStack(spacing: Constants.imageToInfoSpacing) {
            nftImage

            VStack(alignment: .leading, spacing: Constants.infoSpacing) {
                Text(nft.name)
                    .font(Font(UIFont.bodyBold))

                rating

                HStack(spacing: Constants.authorSpacing) {
                    Text("от")
                        .font(Font(UIFont.caption1))

                    Text(nft.author)
                        .font(Font(UIFont.caption2))
                }
            }

            Spacer()

            VStack(alignment: .leading, spacing: Constants.priceSpacing) {
                Text("Цена")
                    .font(Font(UIFont.caption2))

                Text("\(nft.price, specifier: "%.2f") ETH")
                    .font(Font(UIFont.bodyBold))
                    .lineLimit(1)
                    .fixedSize()
            }
        }
        .padding(.trailing, Constants.priceTrailingPadding)
    }
}

private extension NFTRowView {
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

            Image(systemName: "heart.fill")
                .font(.system(size: Constants.heartSize))
                .foregroundStyle(.white)
                .padding(Constants.heartPadding)
        }
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
    NFTRowView(
        nft: Nft(
            id: "1",
            name: "Lilo",
            images: [],
            rating: 3,
            price: 1.78,
            author: "John Doe"
        )
    )
    .padding()
}
