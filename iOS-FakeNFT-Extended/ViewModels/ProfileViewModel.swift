import Foundation
import Observation

@MainActor
@Observable
final class ProfileViewModel {
    private let profileService: ProfileService

    var profile: Profile?
    var isLoading = false
    var error: Error?

    var name = "Имя пользователя"
    var description = "Описание профиля"
    var website = "Сайт"
    var nftCount = 112
    var favoritesCount = 11

    init(profileService: ProfileService) {
        self.profileService = profileService
    }
    
    func loadProfile() async {
        isLoading = true
        error = nil

        do {
            profile = try await profileService.loadProfile()
        } catch {
            self.error = error
        }

        isLoading = false
    }
}
