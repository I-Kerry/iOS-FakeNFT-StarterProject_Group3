import SwiftUI

@main
struct iOS_FakeNFT_ExtendedApp: App {
	@State private var servicesAssembly = ServicesAssembly(
		networkClient: DefaultNetworkClient(),
		nftStorage: NftStorageImpl()
	)
    
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashView()
                    .onAppear {
                        Task {
                            try? await Task.sleep(for: .seconds(2))
                            withAnimation(.easeInOut(duration: 1)) {
                                showSplash = false
                            }
                        }
                    }
                
            } else {
                TabBarView()
                    .environment(servicesAssembly)
            }
        }
    }
}
