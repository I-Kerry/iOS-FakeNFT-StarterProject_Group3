import Foundation

struct NFTRequest: NetworkRequest {

    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}

enum CartRequest: NetworkRequest {
    case order
    case currencies
    case pay(currencyId: String)
    case updateOrder(nftIds: [String])
    
    var endpoint: URL? {
        switch self {
        case .order, .updateOrder:
            URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
        case .currencies:
            URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
        case .pay(let currencyId):
            URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(currencyId)")
        }
    }
    
    var httpMethod: HttpMethod {
        switch self {
        case .updateOrder: .put
        default: .get
        }
    }
}
