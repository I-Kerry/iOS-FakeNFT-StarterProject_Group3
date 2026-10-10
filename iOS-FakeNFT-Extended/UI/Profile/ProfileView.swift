import SwiftUI

struct ProfileView: View {
	
	private enum Constants {
		static let editIconSize: CGFloat = 26
		static let profileImageSize: CGFloat = 70
		static let navigationRowHeight: CGFloat = 54
		static let chevronSize: CGFloat = 14
		static let horizontalPadding: CGFloat = 16
	}
	
	@Environment(ServicesAssembly.self) private var services
	
	@State private var viewModel: ProfileViewModel
	@State private var isWebViewPresented = false
	@State private var isMyNFTPresented = false
	@State private var isFavoritesNFTPresented = false
	
	init(viewModel: ProfileViewModel) {
		_viewModel = State(initialValue: viewModel)
	}
	
	var body: some View {
		VStack(spacing: 0) {
			
			HStack {
				Spacer()
				
				NavigationLink {
					if let profile = viewModel.profile {
						EditProfileView(
							profile: profile,
							viewModel: viewModel
						)
						.toolbar(.hidden, for: .tabBar)
					}
				} label: {
					Image(systemName: "square.and.pencil")
						.font(.system(size: Constants.editIconSize))
						.foregroundStyle(Color(uiColor: .yaBlackLight))
				}
			}
			.padding(.horizontal, Constants.horizontalPadding)
			.padding(.top, 2)
			
			HStack(spacing: 16) {
				AsyncImage(url: viewModel.profile?.avatar) { phase in
					switch phase {
					case .success(let image):
						image
							.resizable()
							.scaledToFill()
						
					default:
						Circle()
							.fill(.gray.opacity(0.3))
					}
				}
				.frame(
					width: Constants.profileImageSize,
					height: Constants.profileImageSize
				)
				.clipShape(Circle())
				
				Text(viewModel.profile?.name ?? "")
					.font(.headline3)
					.foregroundStyle(Color(uiColor: .yaBlackLight))
				
				Spacer()
			}
			.padding(.horizontal, Constants.horizontalPadding)
			.padding(.top, 20)
			
			VStack(alignment: .leading, spacing: 8) {
				Text(viewModel.profile?.description ?? "")
					.font(.caption2)
					.foregroundStyle(Color(uiColor: .yaBlackLight))
				
				Button {
					isWebViewPresented = true
				} label: {
					Text(viewModel.profile?.website.absoluteString ?? "")
						.font(.caption1)
						.foregroundStyle(Color(uiColor: .blueUniversal))
						.multilineTextAlignment(.leading)
						.frame(maxWidth: .infinity, alignment: .leading)
				}
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(.horizontal, Constants.horizontalPadding)
			.padding(.top, 20)
			
			VStack(spacing: 0) {
				Button {
					isMyNFTPresented = true
				} label: {
					ProfileNavigationRow(
						title: NSLocalizedString("Profile.myNFT", comment: ""),
						count: viewModel.profile?.nfts.count ?? 0
					)
				}
				.buttonStyle(.plain)
				
				Button {
					isFavoritesNFTPresented = true
				} label: {
					ProfileNavigationRow(
						title: NSLocalizedString("Profile.favoriteNFT", comment: ""),
						count: viewModel.profile?.likes.count ?? 0
					)
				}
				.buttonStyle(.plain)
			}
			.padding(.top, 40)
			
			Spacer()
		}
		.background(.background)
		.overlay {
			if viewModel.isLoading {
				ProgressView()
					.scaleEffect(1.2)
			}
		}
		.alert(
			NSLocalizedString("Error.title", comment: ""),
			isPresented: .constant(viewModel.loadError != nil)
		) {
			Button(NSLocalizedString("Common.ok", comment: "")) {
				viewModel.loadError = nil
			}
		} message: {
			Text(NSLocalizedString("Profile.loadError", comment: ""))
		}
		.task {
			await viewModel.loadProfile()
		}
		.sheet(isPresented: $isWebViewPresented) {
			if let website = viewModel.profile?.website {
				NavigationStack {
					// ИСПРАВЛЕНИЕ ОШИБКИ: Передали константные Binding-параметры прогресса загрузки 🌟
					WebView(
						url: website,
						progress: .constant(0.0),
						isLoading: .constant(false)
					)
					.toolbar {
						ToolbarItem(placement: .topBarLeading) {
							Button {
								isWebViewPresented = false
							} label: {
								Image(systemName: "chevron.left")
									.foregroundStyle(
										Color(uiColor: .yaBlackLight)
									)
							}
							.buttonStyle(.plain)
						}
					}
				}
			}
		}
		.navigationDestination(isPresented: $isMyNFTPresented) {
			MyNFTView(
				viewModel: MyNFTViewModel(
					nftService: services.nftService,
					nftIDs: viewModel.profile?.nfts ?? []
				)
			)
			.toolbar(.hidden, for: .tabBar)
		}
		.navigationDestination(isPresented: $isFavoritesNFTPresented) {
			FavoritesNFTView(
				viewModel: FavoritesNFTViewModel(
					nftService: services.nftService,
					profileService: services.profileService,
					profile: viewModel.profile,
					onProfileUpdated: { updatedProfile in
						viewModel.profile = updatedProfile
					}
				)
			)
			.toolbar(.hidden, for: .tabBar)
		}
	}
}

private struct ProfileNavigationRow: View {
	
	let title: String
	let count: Int
	
	private enum Constants {
		static let chevronSize: CGFloat = 14
		static let horizontalPadding: CGFloat = 16
		static let rowHeight: CGFloat = 54
	}
	
	var body: some View {
		HStack {
			Text("\(title) (\(count))")
				.font(.bodyBold)
				.foregroundStyle(Color(uiColor: .yaBlackLight))
			
			Spacer()
			
			Image(systemName: "chevron.right")
				.font(
					.system(
						size: Constants.chevronSize,
						weight: .medium
					)
				)
				.foregroundStyle(Color(uiColor: .yaBlackLight))
		}
		.foregroundStyle(.primary)
		.padding(.horizontal, Constants.horizontalPadding)
		.frame(height: Constants.rowHeight)
	}
}

#Preview {
	ProfileView(
		viewModel: ProfileViewModel(
			profileService: ProfileServiceImpl(
				networkClient: DefaultNetworkClient()
			)
		)
	)
}
