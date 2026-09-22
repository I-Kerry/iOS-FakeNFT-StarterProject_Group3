import SwiftUI

struct CatalogView: View {
	@State private var viewModel = CatalogViewModel()
	
	var body: some View {
		ZStack(alignment: .topTrailing) {
			if viewModel.isLoading {
				ProgressView()
					.scaleEffect(1.5)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
			} else {
				ScrollView {
					LazyVStack(spacing: 8) {
						ForEach(viewModel.collections) { collection in
							CatalogRowView(collection: collection)
						}
					}
					.padding(.top, 108)
					.padding(.horizontal, 16)
					.padding(.bottom, 16)
				}
				.scrollIndicators(.hidden)
				.ignoresSafeArea(edges: .top)
			}
			
			Button {
				
			} label: {
				Image("sort_icon")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 21, height: 13)
			}
			.frame(width: 42, height: 42)
			.foregroundColor(.primary)
			.padding(.trailing, 9)
			.padding(.top, 2)
		}
	}
}

struct CatalogRowView: View {
	let collection: NFTCollection
	
	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			Color.gray.opacity(0.2)
				.frame(height: 140)
				.cornerRadius(12)
			
			HStack {
				Text("\(collection.name) (\(collection.nftCount))")
					.font(.system(size: 17, weight: .bold))
					.foregroundColor(.primary)
				Spacer()
			}
			.frame(height: 22)
			.padding(.top, 4)
			.padding(.bottom, 8)
		}
		.frame(height: 179)
	}
}

#Preview {
	CatalogView()
}
