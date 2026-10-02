import Foundation
import Observation

@MainActor
@Observable
final class ProfileViewModel {
    private let profileService: ProfileService

    var profile: Profile?
    var isLoading = false
    var isSaving = false
    var loadError: Error?
    var saveError: Error?

    init(profileService: ProfileService) {
        self.profileService = profileService
    }
    
    func loadProfile() async {
        isLoading = true
        loadError = nil

        do {
            profile = try await profileService.loadProfile()
        } catch {
            loadError = error
        }

        isLoading = false
    }
    
    @discardableResult
    func updateProfile(
        name: String,
        description: String,
        avatar: String,
        website: String
    ) async -> Bool {
        guard let currentProfile = profile else { return false }

        isSaving = true
        saveError = nil

        do {
            profile = try await profileService.updateProfile(
                name: name,
                description: description,
                avatar: avatar,
                website: website,
                likes: currentProfile.likes
            )
            isSaving = false
            return true
        } catch {
            saveError = error
            isSaving = false
            return false
        }
    }
}
