import Foundation

// MARK: - AnalyticsEvent

/// A struct that represents an event that should be sent to the analytics service.
public struct AnalyticsEvent {

    public let id: String
    public let payload: [String: String]?

    public init(id: String, payload: [String: String]?) {
        self.id = id
        self.payload = payload
    }
}
