import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            TestCatalogView()
                .tabItem {
                    Label("Tab.catalog",
                        systemImage: "square.stack.3d.up.fill"
                    )
                }
                .backgroundStyle(.background)
            CartView(viewModel: CartViewModel(cartService: CartServiceImpl(networkClient: DefaultNetworkClient(), nftService: NftServiceImpl(networkClient: DefaultNetworkClient(), storage: NftStorageImpl()))))
                .tabItem {
                    Label("Tab.cart", image: .basket)
                }
                .backgroundStyle(.background)
        }
    }
}
