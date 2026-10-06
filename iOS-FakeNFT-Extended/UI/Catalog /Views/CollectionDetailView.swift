import SwiftUI

@MainActor
struct CollectionDetailView: View {
	private enum AssetImages {
		static let backButton = "chevron.backward"
	}
	
	let collection: NFTCollection
	let servicesAssembly: ServicesAssembly
	
	@State private var viewModel: CollectionDetailViewModel
	
	init(collection: NFTCollection, servicesAssembly: ServicesAssembly) {
		self.collection = collection
		self.servicesAssembly = servicesAssembly
		self._viewModel = State(wrappedValue: CollectionDetailViewModel(service: servicesAssembly.nftService))
	}
	
	@State private var isShowingAuthorWebView = false
	@State private var webViewProgress: Double = 0.0
	@State private var isWebViewLoading = false
	@Environment(\.dismiss) private var dismiss
	
	private let columns = [
		GridItem(.flexible(), spacing: 9),
		GridItem(.flexible(), spacing: 9),
		GridItem(.flexible(), spacing: 9)
	]
	
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
		.task {
			viewModel.loadNfts(ids: collection.nfts ?? [])
		}
	}
	
	private var headerCoverView: some View {
		ZStack(alignment: .topLeading) {
			if let coverString = collection.cover, let url = URL(string: coverString) {
				AsyncImage(url: url) { phase in
					switch phase {
					case .success(let image):
						image
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(height: 310)
							.clipped()
					case .failure, .empty:
						placeholderCover
					@unknown default:
						placeholderCover
					}
				}
				.frame(height: 310)
				.clipShape(
					.rect(
						topLeadingRadius: 0,
						bottomLeadingRadius: 12,
						bottomTrailingRadius: 12,
						topTrailingRadius: 0
					)
				)
			} else {
				placeholderCover
			}
			
			Button {
				dismiss()
			} label: {
				Image(systemName: AssetImages.backButton)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 8.97, height: 15.59)
					.font(.system(size: 24, weight: .medium))
			}
			.frame(width: 24, height: 24)
			.foregroundStyle(.primary)
			.padding(.top, 55)
			.padding(.leading, 9)
		}
		.ignoresSafeArea(edges: .top)
	}
	
	private var placeholderCover: some View {
		Color.gray.opacity(0.2)
			.frame(height: 310)
	}
	
	private var collectionInfoSection: some View {
		Group {
			Text(collection.name)
				.font(.system(size: 22, weight: .bold))
				.tracking(0.35)
				.foregroundStyle(.primary)
				.padding(.horizontal, 16)
				.padding(.top, 16)
			
			HStack(alignment: .firstTextBaseline, spacing: 4) {
				Text("Автор коллекции:")
					.font(.system(size: 13, weight: .regular))
					.tracking(-0.08)
					.foregroundStyle(.primary)
				
				Button {
					isShowingAuthorWebView = true
				} label: {
					Text("John Doe")
						.font(.system(size: 15, weight: .regular))
						.tracking(-0.24)
						.foregroundStyle(.blue)
				}
			}
			.padding(.horizontal, 16)
			.padding(.top, 13)
			.sheet(isPresented: $isShowingAuthorWebView) {
				if let authorString = collection.author, let authorURL = URL(string: authorString) {
					ZStack(alignment: .top) {
						WebView(url: authorURL, progress: $webViewProgress, isLoading: $isWebViewLoading)
							.ignoresSafeArea()
						
						if isWebViewLoading {
							ProgressView(value: webViewProgress, total: 1.0)
								.progressViewStyle(.linear)
								.tint(.blue)
								.background(Color.clear)
								.frame(height: 4)
						}
					}
				} else {
					Text("Неверная ссылка на автора")
						.padding()
				}
			}
			
			Text(collection.description ?? "Описание отсутствует")
				.font(.system(size: 13, weight: .regular))
				.tracking(-0.08)
				.foregroundStyle(.primary)
				.lineSpacing(5)
				.padding(.horizontal, 16)
				.padding(.top, 8)
		}
	}
	
	private var nftGridSection: some View {
		LazyVGrid(columns: columns, spacing: 9) {
			ForEach(collection.nfts ?? [], id: \.self) { nftId in
				let currentNft = viewModel.nfts[nftId]
				
				NavigationLink(destination: Text("Экран NFT (Реализуется наставником)")) {
					NFTItemView(
						nft: currentNft,
						isLiked: viewModel.isLiked(nftId: nftId),
						isInCart: viewModel.isInCart(nftId: nftId),
						onLikeTapped: { viewModel.toggleLike(for: nftId) },
						onCartTapped: { viewModel.toggleCart(for: nftId) }
					)
				}
				.buttonStyle(PlainButtonStyle())
			}
		}
		.padding(.horizontal, 16)
		.padding(.vertical, 24)
	}
}

#Preview {
	NavigationStack {
		CollectionDetailView(
			collection: NFTCollection(
				id: "1",
				name: "Peach",
				cover: "https://yandex.net",
				nfts: ["1", "2", "3"],
				description: "Пушистые шедевры цифрового искусства.",
				author: "https://yandex.ru"
			),
			servicesAssembly: ServicesAssembly(
				networkClient: DefaultNetworkClient(),
				nftStorage: NftStorageImpl()
			)
		)
	}
}
