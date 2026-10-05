import SwiftUI

struct TabBarView: View {
    @Environment(ServicesAssembly.self) private var services
    var body: some View {
        TabView {
            TestCatalogView()
                .tabItem {
                    Label("Tab.catalog",
                        systemImage: "square.stack.3d.up.fill"
                    )
                }
                .backgroundStyle(.background)
            CartView(viewModel: CartViewModel(cartService: services.cartService))
                .tabItem {
                    Label("Tab.cart", image: .basket)
                }
                .backgroundStyle(.background)
        }
    }
}
