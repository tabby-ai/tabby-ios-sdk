import Foundation

public enum BaseURL {
    
    // MARK: - Computed Properties for Dynamic URLs
    public static var checkout: String {
        switch EnvironmentManager.shared.getEnvironment() {
        case .production:
            return "https://api.tabby.ai/api/v2/checkout"
        case .staging:
            return "https://api.tabby.dev/api/v2/checkout"
        }
    }
    
    public static var analyticsURL: String {
        switch EnvironmentManager.shared.getEnvironment() {
        case .production:
            return "https://dp-event-collector.tabby.ai/v1/t"
        case .staging:
            return "https://dp-event-collector.tabby.dev/v1/t"
        }
    }
    
    // MARK: - WebView URLs
    public enum WebView {
        
        public enum Tabby {
            public static var en: String {
                switch EnvironmentManager.shared.getEnvironment() {
                case .production:
                    return "https://checkout.tabby.ai/promos/product-page/installments/en/"
                case .staging:
                    return "https://checkout.tabby.dev/promos/product-page/installments/en/"
                }
            }
            
            public static var ar: String {
                switch EnvironmentManager.shared.getEnvironment() {
                case .production:
                    return "https://checkout.tabby.ai/promos/product-page/installments/ar/"
                case .staging:
                    return "https://checkout.tabby.dev/promos/product-page/installments/ar/"
                }
            }
        }
        
        public enum Widgets {
            public static var url: String {
                switch EnvironmentManager.shared.getEnvironment() {
                case .production:
                    return "https://widgets.tabby.ai/tabby-promo.html"
                case .staging:
                    return "https://widgets.tabby.dev/tabby-promo.html"
                }
            }
        }
        
        public enum Splitit {
            public static var en: String {
                switch EnvironmentManager.shared.getEnvironment() {
                case .production:
                    return "https://checkout.tabby.ai/promos/checkout-page/credit-card-installments/en/"
                case .staging:
                    return "https://checkout.tabby.dev/promos/checkout-page/credit-card-installments/en/"
                }
            }
            
            public static var ar: String {
                switch EnvironmentManager.shared.getEnvironment() {
                case .production:
                    return "https://checkout.tabby.ai/promos/checkout-page/credit-card-installments/ar/"
                case .staging:
                    return "https://checkout.tabby.dev/promos/checkout-page/credit-card-installments/ar/"
                }
            }
        }
    }
}
