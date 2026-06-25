import Foundation

extension SdkConfig.Endpoints {

    static var fallback: SdkConfig.Endpoints {
        SdkConfig.Endpoints(
            checkoutApiBaseUrl: "https://api.tabby.ai",
            webCheckoutBaseUrl: "https://checkout.tabby.ai",
            widgetsBaseUrl: "https://widgets.tabby.ai",
            analyticsBaseUrl: "https://dp-event-collector.tabby.ai"
        )
    }

    static var sdkConfigURL: URL {
        URL(string: "https://api.tabby.ai/api/v1/sdk/config")!
    }
}
