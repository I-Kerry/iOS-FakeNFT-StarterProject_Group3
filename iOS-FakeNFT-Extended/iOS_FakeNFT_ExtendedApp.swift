import SwiftUI

@main
struct iOS_FakeNFT_ExtendedApp: App {
	private let servicesAssembly = ServicesAssembly(
		networkClient: DefaultNetworkClient(),
		nftStorage: NftStorageImpl()
	)

	var body: some Scene {
		WindowGroup {
			CatalogView(servicesAssembly: servicesAssembly)
				.environment(servicesAssembly)
		}
	}
}
