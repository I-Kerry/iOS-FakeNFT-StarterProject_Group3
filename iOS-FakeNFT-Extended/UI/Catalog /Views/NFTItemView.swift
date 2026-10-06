import SwiftUI

struct NFTItemView: View {
	private enum AssetImages {
		static let heartFill = "heart.fill"
	}
	
	let nft: Nft?
	let isLiked: Bool
	let isInCart: Bool
	let onLikeTapped: () -> Void
	let onCartTapped: () -> Void
	
	private let activeHeartColor = Color(red: 245/255, green: 107/255, blue: 108/255)
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			previewSection
			ratingSection
			infoAndCartSection
			
			Spacer(minLength: 0)
		}
		.frame(width: 108, height: 192, alignment: .top)
	}
	
	private var previewSection: some View {
		ZStack(alignment: .topTrailing) {
			if let urlString = nft?.images.first {
				AsyncImage(url: urlString) { phase in
					switch phase {
					case .success(let image):
						image
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(width: 108, height: 108)
							.clipShape(RoundedRectangle(cornerRadius: 12))
					default:
						placeholderImage
					}
				}
			} else {
				placeholderImage
			}
			
			Button {
				onLikeTapped()
			} label: {
				Image(systemName: AssetImages.heartFill)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 21, height: 18)
					.foregroundColor(isLiked ? activeHeartColor : .white)
			}
			.frame(width: 40, height: 40)
			.offset(x: -3, y: 3)
		}
	}
	
	private var ratingSection: some View {
		HStack(spacing: 2) {
			ForEach(0..<5) { index in
				let currentRating = nft?.rating ?? 0
				Image(systemName: index < currentRating ? "star.fill" : "star")
					.resizable()
					.frame(width: 12, height: 12)
					.foregroundColor(index < currentRating ? .yellow : .gray.opacity(0.5))
			}
		}
		.frame(height: 12)
		.padding(.top, 8)
	}
	
	private var infoAndCartSection: some View {
		HStack(alignment: .center, spacing: 0) {
			VStack(alignment: .leading, spacing: 4) {
				Text(nft?.name ?? "Загрузка...")
					.font(.system(size: 15, weight: .bold))
					.tracking(0)
					.foregroundStyle(.primary)
					.lineLimit(1)
					.frame(height: 22)
				
				Text("\(String(format: "%.2f", nft?.price ?? 0.0)) ETH")
					.font(.system(size: 10, weight: .medium))
					.tracking(-0.24)
					.foregroundStyle(.primary)
					.frame(height: 12)
			}
			
			Spacer()
			
			Button {
				onCartTapped()
			} label: {
				Image(isInCart ? .cartRemoveIcon : .cartEmptyIcon)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 19, height: 19)
					.foregroundStyle(.primary)
			}
			.frame(width: 40, height: 40)
		}
		.frame(width: 108, height: 40)
		.padding(.top, 4)
	}
	
	private var placeholderImage: some View {
		Color.gray.opacity(0.3)
			.frame(width: 108, height: 108)
			.clipShape(RoundedRectangle(cornerRadius: 12))
	}
}
