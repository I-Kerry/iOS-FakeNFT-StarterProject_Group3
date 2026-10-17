import SwiftUI

struct CartItemView: View {
	let nft: Nft
	var onDelete: () -> Void = {}
	
	var body: some View {
		HStack {
			AsyncImage(url: nft.imageURLs.first) { phase in
				switch phase {
				case .success(let image):
					image.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(width: Constants.imageSize, height: Constants.imageSize)
						.clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
				default:
					Color.gray.opacity(Constants.opacity)
						.aspectRatio(contentMode: .fit)
						.frame(width: Constants.imageSize, height: Constants.imageSize)
						.clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
				}
			}
			VStack(alignment: .leading, spacing: Constants.infoPriceSpacing) {
				info
				priceInfo
			}
			.padding(.vertical, Constants.topBottomPadding)
			.padding(.leading, Constants.leadingPadding)
			
			Spacer()
			deleteButton
		}
		.padding(Constants.hStackPadding)
	}
	
	@ViewBuilder
	private var info: some View {
		VStack(alignment: .leading, spacing: Constants.infoSpacing) {
			Text(nft.name)
				.font(.bodyBold)
				.foregroundStyle(Color.yaBlack)
			RatingView(rating: nft.rating)
		}
	}
	
	@ViewBuilder
	private var priceInfo: some View {
		VStack(alignment: .leading, spacing: Constants.priceInfoSpacing) {
			Text(Constants.priceTitle)
				.font(.caption2)
				.foregroundStyle(Color.yaBlack)
			Text("\(nft.price, specifier: "%.2f") ETH")
				.font(.bodyBold)
				.foregroundStyle(Color.yaBlack)
		}
	}
	
	@ViewBuilder
	private var deleteButton: some View {
		Button {
			onDelete()
		} label: {
			Image(.cartRemoveIcon)                .renderingMode(.template)
				.foregroundStyle(Color.yaBlack)
				.frame(width: Constants.deleteButtonWidth, height: Constants.deleteButtonHeight)
		}
		.buttonStyle(.plain)
		.frame(width: Constants.buttonSize, height: Constants.buttonSize)
	}
}

private enum Constants {
	static let imageSize: CGFloat = 108
	static let cornerRadius: CGFloat = 12
	static let opacity = 0.2
	static let infoPriceSpacing: CGFloat = 12
	static let topBottomPadding: CGFloat = 8
	static let leadingPadding: CGFloat = 20
	static let hStackPadding: CGFloat = 16
	static let infoSpacing: CGFloat = 4
	static let priceInfoSpacing: CGFloat = 2
	static let deleteButtonWidth: CGFloat = 16
	static let deleteButtonHeight: CGFloat = 18.56
	static let buttonSize: CGFloat = 40
	
	static let priceTitle = String(localized: "Cart.price")
}

#Preview {
	CartItemView(nft: Nft(id: "1", name: "lol", imageURLs: [URL(string: "https://picsum.photos/400/400?random=2")!], rating: 4, price: 5.39, author: "Alonso", description: ""), onDelete: {})
}
