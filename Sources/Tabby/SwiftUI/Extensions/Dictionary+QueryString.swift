import Foundation

extension Dictionary where Key == String {

    var queryString: String {
        var components = URLComponents()
        components.queryItems = map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        return components.percentEncodedQuery ?? ""
    }
}
