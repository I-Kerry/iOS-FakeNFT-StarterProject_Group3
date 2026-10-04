import SwiftUI

struct CatalogView: View {
	@State private var viewModel = CatalogViewModel()
	@State private var isShowingSortMenu = false
	
	var body: some View {
		NavigationStack {
			ZStack {
				VStack(spacing: 0) {
					HStack {
						Spacer()
						Button {
							withAnimation(.easeInOut(duration: 0.2)) {
								isShowingSortMenu = true
							}
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
				
				if isShowingSortMenu {
					Color(.bgSortMenu)						.opacity(0.5)
						.ignoresSafeArea()
						.onTapGesture {
							withAnimation(.easeInOut(duration: 0.2)) {
								isShowingSortMenu = false
							}
						}
					
					VStack(spacing: 0) {
						Spacer()
						
						VStack(spacing: 0) {
							ZStack {
								Text("Сортировка")
									.font(.system(size: 13, weight: .regular))
									.tracking(-0.08)
									.foregroundStyle(Color(red: 60/255, green: 60/255, blue: 67/255).opacity(0.6))
							}
							.frame(height: 42)
							
							Rectangle()
								.frame(height: 0.5)
								.foregroundStyle(Color(red: 60/255, green: 60/255, blue: 67/255).opacity(0.3))
							
							Button {
								viewModel.sortByName()
								withAnimation { isShowingSortMenu = false }
							} label: {
								Text("По названию")
									.font(.system(size: 20, weight: .regular))
									.tracking(0.38)
									.foregroundStyle(Color(red: 10/255, green: 132/255, blue: 255/255))
									.frame(maxWidth: .infinity, maxHeight: .infinity)
									.padding(.horizontal, 16)
							}
							.frame(height: 61)
							
							Rectangle()
								.frame(height: 0.5)
								.foregroundStyle(Color(red: 60/255, green: 60/255, blue: 67/255).opacity(0.3))
							
							Button {
								viewModel.sortByNftCount()
								withAnimation { isShowingSortMenu = false }
							} label: {
								Text("По количеству NFT")
									.font(.system(size: 20, weight: .regular))
									.tracking(0.38)
									.foregroundStyle(Color(red: 10/255, green: 132/255, blue: 255/255))
									.frame(maxWidth: .infinity, maxHeight: .infinity)
									.padding(.horizontal, 16)
							}
							.frame(height: 61)
						}
						.frame(height: 164)
						.background(Color(red: 245/255, green: 245/255, blue: 245/255).opacity(0.7))
						.clipShape(RoundedRectangle(cornerRadius: 13))
						.padding(.horizontal, 8)
						
						Spacer()
							.frame(height: 8)
						
						Button {
							withAnimation(.easeInOut(duration: 0.2)) {
								isShowingSortMenu = false
							}
						} label: {
							Text("Закрыть")
								.font(.system(size: 20, weight: .semibold))
								.tracking(0.38)
								.foregroundStyle(Color(red: 10/255, green: 132/255, blue: 255/255))
								.frame(maxWidth: .infinity, maxHeight: .infinity)
						}
						.frame(height: 61)
						.background(Color(red: 255/255, green: 255/255, blue: 255/255))
						.clipShape(RoundedRectangle(cornerRadius: 13))
						.padding(.horizontal, 8)
					}
					.padding(.bottom, 32)
					.ignoresSafeArea(edges: .bottom)
					.transition(.move(edge: .bottom))
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
