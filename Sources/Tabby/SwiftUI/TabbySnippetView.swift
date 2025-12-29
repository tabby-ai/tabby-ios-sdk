import SwiftUI

// MARK: - Tabby Snippet

@available(iOS 14.0, macOS 11.0, *)
public struct TabbySnippetView: View {

    private let amount: Double
    private let currency: Currency
    private let lang: Lang
    private let shouldInheritBg: Bool

    // MARK: Init
    public init(
        amount: Double,
        currency: Currency,
        lang: Lang = .en,
        shouldInheritBg: Bool = false
    ) {
        self.amount = amount
        self.currency = currency
        self.lang = lang
        self.shouldInheritBg = shouldInheritBg
    }

    // MARK: Body
    public var body: some View {
        let price = Int(amount)
        let queryParams: [String: String] = [
            "price": "\(price)",
            "currency": currency.rawValue,
            "lang": lang.rawValue,
            "publicKey": TabbySDK.shared.apiKey,
            "shouldInheritBg": "\(shouldInheritBg)"
        ]

        return TabbyWebWidgetView(
            widgetURL: BaseURL.WebView.Widgets.promo,
            queryParams: queryParams,
            lang: lang,
            analyticsPrefix: "Snippet"
        )
    }
}
