import Foundation

public enum TabbyEnvironment {
    case production
    case staging
}

extension TabbyEnvironment {
    /// URL of the SDK config endpoint per environment. Used by `SdkConfigService` to bootstrap
    /// region-specific URLs; everything downstream comes from the response.
    var sdkConfigURL: URL {
        switch self {
        case .production:
            return URL(string: "https://api.tabby.ai/api/v1/sdk/config")!
        case .staging:
            return URL(string: "https://api.tabby.dev/api/v1/sdk/config")!
        }
    }
}

public final class EnvironmentManager {
    public static let shared = EnvironmentManager()
    
    private var currentEnvironment: TabbyEnvironment = .production
    
    private init() {}
    
    public func setEnvironment(_ environment: TabbyEnvironment) {
        currentEnvironment = environment
    }
    
    public func getEnvironment() -> TabbyEnvironment {
        return currentEnvironment
    }
}
