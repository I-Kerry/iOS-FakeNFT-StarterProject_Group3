import Foundation
enum RequestConstants {
    static let baseURL = "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net"
    static let token: String = {
        guard let token = Bundle.main.object(forInfoDictionaryKey: "API_TOKEN") as? String else {
            fatalError("API_TOKEN not set in Info.plist")
        }
        return token
    }()
}
