import Foundation
import Observation

@MainActor
@Observable
final class EditProfileViewModel {
    let profile: Profile

    var name: String
    var description: String
    var avatarURL: URL?
    var website: String
    var isAvatarDeleted = false

    var hasChanges: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && (
            name != profile.name
            || description != profile.description
            || website != profile.website.absoluteString
            || avatarURL != profile.avatar
            || isAvatarDeleted
        )
    }

    init(profile: Profile) {
        self.profile = profile
        name = profile.name
        description = profile.description
        avatarURL = profile.avatar
        website = profile.website.absoluteString
    }
}
