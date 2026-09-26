import SwiftUI

struct CollectionDetailView: View {
	// MARK: - Properties
	let collection: NFTCollection
	@Environment(\.dismiss) private var dismiss
	
	private let columns = [
		GridItem(.flexible(), spacing: 9),
		GridItem(.flexible(), spacing: 9),
		GridItem(.flexible(), spacing: 9)
	]
	
	// MARK: - Body
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 0) {
				headerCoverView
				collectionInfoSection
				nftGridSection
			}
		}
		.scrollIndicators(.hidden)
		.navigationBarBackButtonHidden(true)
		.navigationBarHidden(true)
	}
	
	// MARK: - Subviews
	
	private var headerCoverView: some View {
		ZStack(alignment: .topLeading) {
			Color.gray.opacity(0.2)
				.frame(height: 310)
				.clipShape(
					.rect(
						topLeadingRadius: 0,
						bottomLeadingRadius: 12,
						bottomTrailingRadius: 12,
						topTrailingRadius: 0
					)
				)
			
			Button {
				dismiss()
			} label: {
				Image(systemName: "chevron.backward")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 8.97, height: 15.59)
					.font(.system(size: 24, weight: .medium))
			}
			.frame(width: 24, height: 24)
			.foregroundColor(.primary)
			.padding(.top, 55)
			.padding(.leading, 9) // Исправлена опечатка из макета
		}
		.ignoresSafeArea(edges: .top)
	}
	
	private var collectionInfoSection: some View {
		Group {
			Text(collection.name)
				.font(.system(size: 22, weight: .bold))
				.tracking(0.35)
				.foregroundColor(.primary)
				.padding(.horizontal, 16)
				.padding(.top, 16)
			
			HStack(alignment: .firstTextBaseline, spacing: 4) {
				Text(String(localized: "Автор коллекции:"))
					.font(.system(size: 13, weight: .regular))
					.tracking(-0.08)
					.foregroundColor(.primary)
				
				Button {
					// Действие при клике на автора
				} label: {
					Text("John Doe")
						.font(.system(size: 15, weight: .regular))
						.tracking(-0.24)
						.foregroundColor(.blue)
				}
			}
			.padding(.horizontal, 16)
			.padding(.top, 13)
			
			Text(collection.description)
				.font(.system(size: 13, weight: .regular))
				.tracking(-0.08)
				.foregroundColor(.primary)
				.lineSpacing(5)
				.padding(.horizontal, 16)
				.padding(.top, 8)
		}
	}
	
	private var nftGridSection: some View {
		LazyVGrid(columns: columns, spacing: 9) {
			ForEach(collection.nfts, id: \.self) { nftId in
				NFTItemView(nftId: nftId, rating: 4)
			}
		}
		.padding(.horizontal, 16)
		.padding(.top, 24)
		.padding(.bottom, 24)
	}
}

// MARK: - Preview
#Preview {
	NavigationStack {
		CollectionDetailView(collection: NFTCollection(
			id: "1",
			name: "Peach",
			cover: "https://yandex.net",
			nfts: ["1", "2", "3", "4", "5", "6", "7", "8", "9"],
			description: "Пушистые шедевры цифрового искусства. Коллекция Персик объединяет самых нежных и грациозных представителей кошачьего мира.",
			author: "https://yandex.ru"
		))
	}
}
