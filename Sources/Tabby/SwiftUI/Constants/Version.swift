import Foundation

let version = "1.7.8"

/// `X-SDK-Version` header sent on every outbound SDK request. Defined once so the format
/// (`<platform>/<version>`) and casing stay identical across the Checkout API, analytics,
/// and `/sdk/config` calls.
enum SdkVersionHeader {
    static let key = "X-SDK-Version"
    static let value = "iOS/\(version)"
}
