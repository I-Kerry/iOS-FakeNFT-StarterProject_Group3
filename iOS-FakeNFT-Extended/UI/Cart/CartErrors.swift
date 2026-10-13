import Foundation

enum CartErrors: LocalizedError {
    case paymentFailed
    
    var errorDescription: String? {
        switch self {
        case .paymentFailed: String(localized: "Cart.paymentFailedError") }
    }
}
