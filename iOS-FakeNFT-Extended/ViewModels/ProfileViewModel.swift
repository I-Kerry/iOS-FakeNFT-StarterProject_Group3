import Foundation
import Observation

@MainActor
@Observable
final class ProfileViewModel {
    private let profileService: ProfileService

    var profile: Profile?
    var isLoading = false
    var isSaving = false
    var error: Error?

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
    
    @discardableResult
    func updateProfile(
        name: String,
        description: String,
        avatar: String,
        website: String
    ) async -> Bool {
        guard let currentProfile = profile else { return false }

        isSaving = true
        error = nil

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
            self.error = error
            isSaving = false
            return false
        }
    }
}
