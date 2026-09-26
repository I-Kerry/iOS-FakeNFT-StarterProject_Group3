import SwiftUI

struct CollectionDetailView: View {
	let collection: NFTCollection
	@Environment(\.dismiss) private var dismiss
	
	private let columns = [
		GridItem(.fixed(108), spacing: 16),
		GridItem(.fixed(108), spacing: 16)
	]
	
	var body: some View {
		ScrollView {
			// Один главный контейнер без лишних вложенных VStack
			VStack(alignment: .leading, spacing: 0) {
				
				// 1. Обложка + Кнопка Назад
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
					.padding(.leading, 9)
				}
				.ignoresSafeArea(edges: .top)
				
				// 2. Заголовок коллекции
				Text(collection.name)
					.font(.system(size: 22, weight: .bold))
					.tracking(0.35)
					.foregroundColor(.primary)
					.padding(.horizontal, 16) // Четкие 16 пунктов от края стекла!
					.padding(.top, 16)
				
				// 3. Блок автора коллекции
				HStack(alignment: .firstTextBaseline, spacing: 4) {
					Text(String(localized: "Автор коллекции:"))
						.font(.system(size: 13, weight: .regular))
						.tracking(-0.08)
						.foregroundColor(.primary)
					
					Button {
						// Логика открытия сайта (Итерация 2)
					} label: {
						Text("John Doe")
							.font(.system(size: 15, weight: .regular))
							.tracking(-0.24)
							.foregroundColor(.blue)
					}
				}
				.padding(.horizontal, 16) // Четкие 16 пунктов от края стекла!
				.padding(.top, 13)
				
				// 4. Текст описания коллекции
				Text(collection.description)
					.font(.system(size: 13, weight: .regular))
					.tracking(-0.08)
					.foregroundColor(.primary)
					.lineSpacing(5) // Line height 18px
					.padding(.horizontal, 16) // Четкие 16 пунктов от края стекла!
					.padding(.top, 8)
				
				// 5. Сетка NFT-товаров
				HStack {
					Spacer()
					LazyVGrid(columns: columns, spacing: 28) {
						ForEach(collection.nfts, id: \.self) { nftId in
							VStack {
								Color.gray.opacity(0.3)
									.frame(width: 108, height: 108)
									.cornerRadius(12)
								Text("NFT ID: \(nftId)")
									.font(.caption)
							}
						}
					}
					Spacer()
				}
				.padding(.top, 24)
				.padding(.bottom, 24)
			}
		}
		.scrollIndicators(.hidden)
		.navigationBarBackButtonHidden(true)
		.navigationBarHidden(true)
	}
}

#Preview {
	NavigationStack {
		CollectionDetailView(collection: NFTCollection(
			id: "1",
			name: "Peach",
			cover: "https://yandex.net",
			nfts: ["1", "2", "3", "4"],
			description: "Пушистые шедевры цифрового искусства. Коллекция Персик объединяет самых нежных и грациозных представителей кошачьего мира.",
			author: "https://yandex.ru"
		))
	}
}
