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
		static let heartTopPadding: CGFloat = 10
		static let heartTrailingPadding: CGFloat = 8
		static let infoToPriceSpacing: CGFloat = 30
		static let zeroSpacing: CGFloat = 0
		static let priceWidth: CGFloat = 85
	}
	
	let nft: Nft
	
	var body: some View {
		HStack(spacing: Constants.zeroSpacing) {
			nftImage
				.padding(.trailing, Constants.imageToInfoSpacing)
			
			VStack(alignment: .leading, spacing: Constants.infoSpacing) {
				Text(nft.name)
					.font(.bodyBold)
				
				rating
				
				HStack(spacing: Constants.authorSpacing) {
					Text(NSLocalizedString("NFT.from", comment: ""))
						.font(.caption1)
					
					Text(nft.author)
						.font(.caption2)
				}
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(.trailing, Constants.infoToPriceSpacing)
			
			VStack(alignment: .leading, spacing: Constants.priceSpacing) {
				Text(NSLocalizedString("NFT.price", comment: ""))
					.font(.caption2)
				
				Text("\(nft.price, specifier: "%.2f") ETH")
					.font(.bodyBold)                    .lineLimit(1)
					.fixedSize()
			}
			.frame(width: Constants.priceWidth, alignment: .leading)
		}
	}
}

private extension NFTRowView {
	var nftImage: some View {
		ZStack(alignment: .topTrailing) {
			AsyncImage(url: nft.imageURLs.first) { phase in
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
				.padding(.top, Constants.heartTopPadding)
				.padding(.trailing, Constants.heartTrailingPadding)
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
			imageURLs: [],
			rating: 3,
			price: 1.78,
			author: "John Doe",
			description: "Sample description"
		)
	)
	.padding()
}
