import SwiftUI

struct ContentView: View {
    var body: some View {
        ProfileView(
            viewModel: ProfileViewModel(
                profileService: ProfileServiceImpl(
                    networkClient: DefaultNetworkClient()
                )
            )
        )
    }
}
