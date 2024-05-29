import Foundation

final public class AnalyticsService {
    
    // MARK: - Shared
    
    internal static let shared = AnalyticsService(networkService: .shared)
    
    // MARK: - Public
    
    internal var baseURL: String = Constants.analyticsBaseURL(for: .prod)
    
    // MARK: - Private
    
    private let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
        
    private let networkService: NetworkService
    private let sessionId: String = UUID().uuidString
    
    private var context = AnalyticsContext()
    
    // MARK: - Init
    
    private init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    // MARK: - Context
    
    internal func setContextItem(_ contextItem: AnalyticsContextItem) {
        context[contextItem.key] = contextItem
    }
    
    internal func removeContextItem(by key: AnalyticsContextItem.Key) {
        context.removeItem(by: key)
    }
    
    internal func clearContext() {
        context.clear()
    }
    
    // MARK: - Public methods
    
    internal func send(event: AnalyticsEvent) {
        networkService.performRequest(
            url: baseURL,
            method: "POST",
            headers: [
                "Content-Type": "application/json",
                "Accept": "application/json",
                "X-SDK-Version": "iOS/\(version)",
                "Authorization": "Basic \(getAnalyticsHeader())"
            ], 
            body: preparePayload(event: event)) { (result: Result<Data?, Error>) in
                
            }
    }
    
    // MARK: - Private methods
    
    private func preparePayload(event: AnalyticsEvent) -> Encodable {
        [
            "anonymousId": sessionId,
            "messageId": UUID().uuidString,
            "properties": (event.payload ?? [:]).merging(context.build()) { (old, _) in old },
            "mobileSDK": true,
            "context": [
                "source": "ios-sdk",
                "direct": true
            ],
            "type": "track",
            "event": event.id,
            "timestamp": dateFormatter.string(from: Date()),
            "integrations": [
                "Segment.io": true
            ]
        ].mapValues { AnyCodable($0) }
    }
}
