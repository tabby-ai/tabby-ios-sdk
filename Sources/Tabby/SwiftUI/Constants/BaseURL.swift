import Foundation

public enum BaseURL {
    
    // MARK: - Computed Properties for Dynamic URLs
    public static var checkout: String {
        return "https://api.tabby.ai/api/v2/checkout"
    }
    
    public static var analyticsURL: String {
        return "https://dp-event-collector.tabby.ai/v1/t"
    }
    
    // MARK: - WebView URLs
    public enum WebView {
        
        public enum Tabby {
            public static var en: String {
                return "https://checkout.tabby.ai/promos/product-page/installments/en/"
            }
            
            public static var ar: String {
                return "https://checkout.tabby.ai/promos/product-page/installments/ar/"
            }
        }
        
        public enum Widgets {
            public static var url: String {
                return "https://widgets.tabby.ai/tabby-promo.html"
            }
        }
        
        public enum Splitit {
            public static var en: String {
                return "https://checkout.tabby.ai/promos/checkout-page/credit-card-installments/en/"
            }
            
            public static var ar: String {
                return "https://checkout.tabby.ai/promos/checkout-page/credit-card-installments/ar/"
            }
        }
    }
}
