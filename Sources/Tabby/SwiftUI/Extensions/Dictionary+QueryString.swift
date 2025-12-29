import Foundation

extension Dictionary where Key == String {

    var queryString: String {
        map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
    }
}
