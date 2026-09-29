import SwiftUI

struct CatalogView: View {
	@State private var viewModel = CatalogViewModel()
	
	var body: some View {
		NavigationStack {
			ZStack {
				if viewModel.isLoading {
					ProgressView()
						.scaleEffect(1.5)
						.frame(maxWidth: .infinity, maxHeight: .infinity)
				} else {
					VStack(spacing: 0) {
						HStack {
							Spacer()
							Button {
								
							} label: {
								Image(.sortIcon)
									.resizable()
									.aspectRatio(contentMode: .fit)
									.frame(width: 21, height: 13)
							}
							.frame(width: 42, height: 42)
							.foregroundStyle(.primary)
						}
						.padding(.trailing, 9)
						.padding(.top, 44)
						.padding(.bottom, 20)
						
						ScrollView {
							LazyVStack(spacing: 8) {
								ForEach(viewModel.collections) { collection in
									NavigationLink(destination: CollectionDetailView(collection: collection)) {
										CatalogRowView(collection: collection)
									}
									.buttonStyle(PlainButtonStyle())
								}
							}
							.padding([.horizontal, .bottom], 16)
						}
						.scrollIndicators(.hidden)
					}
					.ignoresSafeArea(edges: .top)
				}
			}
		}
	}
}

struct CatalogRowView: View {
	let collection: NFTCollection
	
	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			Color.gray.opacity(0.2)
				.frame(height: 140)
				.clipShape(RoundedRectangle(cornerRadius: 12))
			
			HStack {
				Text("\(collection.name) (\(collection.nftCount))")
					.font(.system(size: 17, weight: .bold))
					.foregroundStyle(.primary)
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
