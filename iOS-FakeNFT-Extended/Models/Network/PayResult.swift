import Foundation

struct PayResult: Sendable, Decodable {
    var success: Bool
    var orderId: String
}
