import SwiftUI

@main
struct iOS_FakeNFT_ExtendedApp: App {
	private let servicesAssembly: ServicesAssembly

	init() {
		let networkClient = DefaultNetworkClient()
		let nftStorage = NftStorageImpl()
		
		self.servicesAssembly = ServicesAssembly(
			networkClient: networkClient,
			nftStorage: nftStorage
		)
	}

	var body: some Scene {
		WindowGroup {
			// Временно запускаем ваш Каталог вместо ContentView!
			CatalogView(servicesAssembly: servicesAssembly)
		}
	}
}
