import Foundation

struct ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
}

struct UpdateProfileRequest: NetworkRequest {
    let name: String
    let description: String
    let avatar: String
    let website: String
    let likes: [String]

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }

    var httpMethod: HttpMethod {
        .put
    }

    var contentType: String? {
        "application/x-www-form-urlencoded"
    }

    var body: Data? {
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "name", value: name),
            URLQueryItem(name: "description", value: description),
            URLQueryItem(name: "avatar", value: avatar),
            URLQueryItem(name: "website", value: website)
        ]

        if likes.isEmpty {
            components.queryItems?.append(
                URLQueryItem(name: "likes", value: "null")
            )
        } else {
            likes.forEach { like in
                components.queryItems?.append(
                    URLQueryItem(name: "likes", value: like)
                )
            }
        }
        
        return components.percentEncodedQuery?
            .replacingOccurrences(of: "+", with: "%2B")
            .data(using: .utf8)
    }
}
