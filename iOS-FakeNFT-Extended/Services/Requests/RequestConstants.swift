import Foundation

enum RequestConstants {
	static let baseURL = "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net"
	static let token: String = {
		guard let token = Bundle.main.infoDictionary?["ApiToken"] as? String else {
			fatalError("API Token missing in Info.plist configuration")
		}
		return token
	}()
}
