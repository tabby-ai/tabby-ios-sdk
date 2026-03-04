import SwiftUI

// MARK: - Tabby Snippet

/// Promotional snippet for product and cart pages.
///
/// Displays split payment information with a "Learn More" link that opens a modal
/// explaining Tabby's payment options. Use this on product detail pages or cart pages
/// to show customers how they can split their payment.
///
/// Example:
/// ```swift
/// TabbySnippetView(
///     amount: 1990,
///     currency: .SAR,
///     lang: .en,
///     shouldInheritBg: false
/// )
/// .frame(height: 100)
/// ```
@available(iOS 14.0, macOS 11.0, *)
public struct TabbySnippetView: View {

    private let amount: Double
    private let currency: Currency
    private let lang: Lang
    private let shouldInheritBg: Bool

    // MARK: Init

    /// Creates a promotional snippet for product or cart pages.
    ///
    /// - Parameters:
    ///   - amount: Product or cart total amount
    ///   - currency: Currency code (`.AED`, `.SAR`, `.KWD`, etc.)
    ///   - lang: Display language (default: `.en`)
    ///   - shouldInheritBg: Inherit background color from parent view (default: `false`)
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
