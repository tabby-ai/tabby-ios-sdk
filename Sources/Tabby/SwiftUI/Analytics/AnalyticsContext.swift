import Foundation

// MARK: - AnalyticsContext

struct AnalyticsContext {
    
    private var contextBuilders: [AnalyticsContextItem.Key: AnalyticsContextItem] = [:]
    
    func build() -> [String: String] {
        contextBuilders.values.reduce(into: [:]) { result, builder in
            result.merge(builder.build()) { _, new in new }
        }
    }
    
    mutating func removeItem(by key: AnalyticsContextItem.Key) {
        contextBuilders.removeValue(forKey: key)
    }
    
    mutating func clear() {
        contextBuilders.removeAll()
    }
    
    subscript(key: AnalyticsContextItem.Key) -> AnalyticsContextItem? {
        get { contextBuilders[key] }
        set { contextBuilders[key] = newValue }
    }
}

// MARK: - AnalyticsContextItem

struct AnalyticsContextItem {
    
    struct Key: Hashable, ExpressibleByStringLiteral {
                
        let value: String
        
        init(stringLiteral value: StringLiteralType) {
            self.value = value
        }
    }
    
    var key: Key
    var build: () -> [String: String]
}

// MARK: - Contexts

// MARK: TabbySDK

extension AnalyticsContextItem.Key {
    
    static let tabbySDK: Self = "tabbySDK"
}

extension AnalyticsContextItem {
    
    static func tabbySDK(apiKey: String) -> AnalyticsContextItem {
        Self(key: .tabbySDK) {
            [
                "publicKey": apiKey,
                "version": version
            ]
        }
    }
}
