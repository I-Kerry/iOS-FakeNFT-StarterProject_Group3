import SwiftUI

@main
struct iOS_FakeNFT_ExtendedApp: App {
	@State private var servicesAssembly = ServicesAssembly(
		networkClient: DefaultNetworkClient(),
		nftStorage: NftStorageImpl()
	)
	
	var body: some Scene {
		WindowGroup {
			TabBarView()
				.environment(servicesAssembly)
		}
	}
}
