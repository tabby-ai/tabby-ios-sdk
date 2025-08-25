public enum TabbyEnvironment {
    case production
    case staging
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
