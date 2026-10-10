import SwiftUI

struct CatalogView: View {
	private enum Constants {
		static let sortIconWidth: CGFloat = 21
		static let sortIconHeight: CGFloat = 13
		static let sortButtonSize: CGFloat = 42
		static let topHeaderPadding: CGFloat = 44
		static let bottomHeaderPadding: CGFloat = 20
		static let listHorizontalPadding: CGFloat = 16
		static let listBottomPadding: CGFloat = 8
		static let progressScale: CGFloat = 1.5
		static let progressBgOpacity: Double = 0.3
		static let headerTrailingPadding: CGFloat = 9
		static let animationDuration: Double = 0.2
	}
	
	let servicesAssembly: ServicesAssembly
	
	@State private var viewModel: CatalogViewModel
	@State private var isShowingSortMenu = false
	
	init(servicesAssembly: ServicesAssembly) {
		self.servicesAssembly = servicesAssembly
		_viewModel = State(initialValue: CatalogViewModel(service: servicesAssembly.nftService))
	}
	
	var body: some View {
		NavigationStack {
			ZStack {
				VStack(spacing: 0) {
					HStack {
						Spacer()
						Button {
							withAnimation(.easeInOut(duration: Constants.animationDuration)) {
								isShowingSortMenu = true
							}
						} label: {
							Image(.sortIcon)
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(width: Constants.sortIconWidth, height: Constants.sortIconHeight)
						}
						.frame(width: Constants.sortButtonSize, height: Constants.sortButtonSize)
						.foregroundStyle(.primary)
					}
					.padding(.trailing, Constants.headerTrailingPadding)
					.padding(.top, Constants.topHeaderPadding)
					.padding(.bottom, Constants.bottomHeaderPadding)
					
					List {
						ForEach(viewModel.collections) { collection in
							ZStack {
								NavigationLink(destination: CollectionDetailView(collection: collection, servicesAssembly: servicesAssembly)) {
									EmptyView()
								}
								.opacity(0)
								CatalogRowView(collection: collection)
							}
							.listRowInsets(EdgeInsets())
							.listRowSeparator(.hidden)
							.listRowBackground(Color.clear)
							.padding(.horizontal, Constants.listHorizontalPadding)
							.padding(.bottom, Constants.listBottomPadding)
						}
					}
					.listStyle(.plain)
					.scrollIndicators(.hidden)
				}
				.ignoresSafeArea(edges: .top)
				
				if viewModel.isLoading {
					ProgressView()
						.scaleEffect(Constants.progressScale)
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.background(Color(.systemBackground).opacity(Constants.progressBgOpacity))
				}
				
				if isShowingSortMenu {
					CatalogSortMenuView(
						isPresented: $isShowingSortMenu,
						onSortByName: { viewModel.sortByName() },
						onSortByCount: { viewModel.sortByNftCount() }
					)
				}
			}
			.alert("Ошибка", isPresented: $viewModel.showNetworkAlert) {
				Button("Повторить") {
					Task {
						await viewModel.fetchCatalogData()
					}
				}
				Button("Отмена", role: .cancel) { }
			} message: {
				Text(viewModel.alertErrorMessage)
			}
			.task {
				await viewModel.fetchCatalogData()
			}
		}
	}
}
