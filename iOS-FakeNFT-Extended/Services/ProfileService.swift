import Foundation

protocol ProfileService: Sendable {
    func loadProfile() async throws -> Profile
}

actor ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadProfile() async throws -> Profile {
        let request = ProfileRequest()
        return try await networkClient.send(request: request)
    }
}
