import SwiftUI

struct CatalogRowView: View {
	private enum RowConstants {
		static let imageHeight: CGFloat = 140
		static let cornerRadius: CGFloat = 12
		static let titleHeight: CGFloat = 22
		static let titleTopPadding: CGFloat = 4
		static let titleBottomPadding: CGFloat = 8
		static let totalHeight: CGFloat = 179
		static let placeholderOpacity: Double = 0.2
	}
	
	let collection: NFTCollection
	
	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			if let coverString = collection.cover, let url = URL(string: coverString) {
				AsyncImage(url: url) { phase in
					switch phase {
					case .success(let image):
						image
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(height: RowConstants.imageHeight)
							.clipShape(RoundedRectangle(cornerRadius: RowConstants.cornerRadius))
					case .failure:
						placeholderView
					case .empty:
						ZStack {
							placeholderView
							ProgressView()
						}
					@unknown default:
						placeholderView
					}
				}
			} else {
				placeholderView
			}
			
			HStack {
				Text("\(collection.name) (\(collection.nftCount))")
					.font(.system(size: 17, weight: .bold))
					.foregroundStyle(.primary)
				Spacer()
			}
			.frame(height: RowConstants.titleHeight)
			.padding(.top, RowConstants.titleTopPadding)
			.padding(.bottom, RowConstants.titleBottomPadding)
		}
		.frame(height: RowConstants.totalHeight)
	}
	
	private var placeholderView: some View {
		Color.gray.opacity(RowConstants.placeholderOpacity)
			.frame(height: RowConstants.imageHeight)
			.clipShape(RoundedRectangle(cornerRadius: RowConstants.cornerRadius))
	}
}
