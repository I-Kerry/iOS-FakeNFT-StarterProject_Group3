import SwiftUI

@MainActor
struct CollectionDetailView: View {
	private enum Constants {
		static let coverHeight: CGFloat = 310
		static let backButtonIconWidth: CGFloat = 8.97
		static let backButtonIconHeight: CGFloat = 15.59
		static let backButtonFrameSize: CGFloat = 24
		static let backButtonTopPadding: CGFloat = 55
		static let backButtonLeadingPadding: CGFloat = 9
		static let placeholderOpacity: Double = 0.2
		static let gridSpacing: CGFloat = 9
		static let infoHorizontalPadding: CGFloat = 16
		static let infoTopPadding: CGFloat = 16
		static let authorTopPadding: CGFloat = 13
		static let authorSpacing: CGFloat = 4
		static let descriptionTopPadding: CGFloat = 8
		static let lineSpacing: CGFloat = 5
		static let gridVerticalPadding: CGFloat = 24
	}
	
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
		GridItem(.flexible(), spacing: Constants.gridSpacing),
		GridItem(.flexible(), spacing: Constants.gridSpacing),
		GridItem(.flexible(), spacing: Constants.gridSpacing)
	]
	
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 0) {
				headerCoverView
					.overlay(alignment: .topLeading) {
						backButtonOverlay
					}
				
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
							.frame(height: Constants.coverHeight)
							.clipped()
					case .failure, .empty:
						placeholderCover
					@unknown default:
						placeholderCover
					}
				}
				.frame(height: Constants.coverHeight)
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
		}
		.ignoresSafeArea(edges: .top)
	}
	
	private var backButtonOverlay: some View {
		HStack {
			Button {
				dismiss()
			} label: {
				Image(systemName: AssetImages.backButton)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: Constants.backButtonIconWidth, height: Constants.backButtonIconHeight)
					.font(.system(size: 24, weight: .medium))
			}
			.frame(width: Constants.backButtonFrameSize, height: Constants.backButtonFrameSize)
			.foregroundStyle(.primary)
			.padding(.top, Constants.backButtonTopPadding)
			.padding(.leading, Constants.backButtonLeadingPadding)
			
			Spacer()
		}
		.ignoresSafeArea(edges: .top)
		.zIndex(1)
	}
	
	private var placeholderCover: some View {
		Color.gray.opacity(Constants.placeholderOpacity)
			.frame(height: Constants.coverHeight)
	}
	
	private var collectionInfoSection: some View {
		Group {
			Text(collection.name)
				.font(.system(size: 22, weight: .bold))
				.tracking(0.35)
				.foregroundStyle(.primary)
				.padding(.horizontal, Constants.infoHorizontalPadding)
				.padding(.top, Constants.infoTopPadding)
			
			HStack(alignment: .firstTextBaseline, spacing: Constants.authorSpacing) {
				Text("Автор коллекции:")
					.font(.system(size: 13, weight: .regular))
					.tracking(-0.08)
					.foregroundStyle(.primary)
				
				Button {
					isShowingAuthorWebView = true
				} label: {
					Text(collection.authorName)
						.font(.system(size: 15, weight: .regular))
						.tracking(-0.24)
						.foregroundStyle(.blue)
				}
			}
			.padding(.horizontal, Constants.infoHorizontalPadding)
			.padding(.top, Constants.authorTopPadding)
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
				.lineSpacing(Constants.lineSpacing)
				.padding(.horizontal, Constants.infoHorizontalPadding)
				.padding(.top, Constants.descriptionTopPadding)
		}
	}
	
	private var nftGridSection: some View {
		LazyVGrid(columns: columns, spacing: Constants.gridSpacing) {
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
		.padding(.horizontal, Constants.infoHorizontalPadding)
		.padding(.vertical, Constants.gridVerticalPadding)
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
