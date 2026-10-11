import SwiftUI

struct TabBarView: View {
	
	@Environment(ServicesAssembly.self) private var services
	
	init() {
		let appearance = UITabBarAppearance()
		appearance.configureWithDefaultBackground()

        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(
            named: "BlackUniversal"
        )

        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(named: "BlackUniversal") ?? .black
        ]

		UITabBar.appearance().standardAppearance = appearance
	}
	
	var body: some View {
		TabView {
			NavigationStack {
				ProfileView(
					viewModel: ProfileViewModel(
						profileService: services.profileService
					)
				)
			}
			.tabItem {
				Label(
					NSLocalizedString("Tab.profile", comment: ""),
					systemImage: "person.crop.circle"
				)
			}
			
			CatalogView(servicesAssembly: services)
				.tabItem {
					Label(
						NSLocalizedString("Tab.catalog", comment: ""),
						systemImage: "square.stack.3d.up.fill"
					)
				}
				.backgroundStyle(.background)
		}
	}
}
