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
///     shouldInheritBg: false,
///     merchantCode: "SA"
/// )
/// .frame(height: 100)
/// ```
@available(iOS 14.0, macOS 11.0, *)
public struct TabbySnippetView: View {

    private let amount: Double
    private let currency: Currency
    private let lang: Lang
    private let shouldInheritBg: Bool
    private let merchantCode: String

    @State private var widgetsBaseUrl: String?

    // MARK: Init

    /// Creates a promotional snippet for product or cart pages.
    ///
    /// - Parameters:
    ///   - amount: Product or cart total amount
    ///   - currency: Currency code (`.AED`, `.SAR`, `.KWD`, etc.)
    ///   - lang: Display language (default: `.en`)
    ///   - shouldInheritBg: Inherit background color from parent view (default: `false`)
    ///   - merchantCode: Merchant code for your currency (e.g., "SA" for SAR, "AE" for AED, "KW" for KWD)
    public init(
        amount: Double,
        currency: Currency,
        lang: Lang = .en,
        shouldInheritBg: Bool = false,
        merchantCode: String
    ) {
        self.amount = amount
        self.currency = currency
        self.lang = lang
        self.shouldInheritBg = shouldInheritBg
        self.merchantCode = merchantCode
    }

    private var queryParams: [String: String] {
        [
            "price": "\(Int(amount))",
            "currency": currency.rawValue,
            "lang": lang.rawValue,
            "publicKey": TabbySDK.shared.apiKey,
            // The widget needs merchantCode to map the account and show all plans
            // available for it; without it only the default plans render (MPC-2731).
            "merchantCode": merchantCode,
            "shouldInheritBg": "\(shouldInheritBg)"
        ]
    }

    // MARK: Body
    public var body: some View {
        Group {
            if let widgetsBaseUrl = widgetsBaseUrl {
                TabbyWebWidgetView(
                    widgetURL: "\(widgetsBaseUrl)/tabby-promo.html",
                    queryParams: queryParams,
                    lang: lang,
                    analyticsPrefix: "Snippet",
                    transparentBackground: shouldInheritBg
                )
            } else {
                // Waiting for /sdk/config — webapp handles its own shimmer once we know the
                // right regional URL, so nothing native to show here.
                Color.clear
            }
        }
        .onAppear { resolveEndpoints() }
        // Currency picks the geo-sharded host (e.g. SAR → widgets.tabby.sa), so a currency
        // change must re-resolve the base URL, not just update query params (MPC-2731).
        .onChange(of: currency) { _ in resolveEndpoints() }
    }

    private func resolveEndpoints() {
        Task { @MainActor in
            widgetsBaseUrl = await TabbySDK.shared.sdkConfigService.endpoints(for: currency).widgetsBaseUrl
        }
    }
}
