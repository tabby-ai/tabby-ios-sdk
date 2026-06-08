import SwiftUI

// MARK: - Tabby Card (Checkout Snippet)

/// Checkout page snippet displaying payment information.
///
/// Shows payment details under the Tabby payment method option on checkout pages.
/// Includes a "Learn More" link that opens a modal explaining Tabby's payment options.
///
/// Display this snippet when the Tabby payment method is selected during checkout.
///
/// Example:
/// ```swift
/// TabbyCardView(
///     amount: 1600.00,
///     currency: .SAR,
///     lang: .en,
///     shouldInheritBg: false,
///     merchantCode: "SA"
/// )
/// .frame(height: 120)
/// ```
///
/// - Note: Replaces the deprecated `TabbyCheckoutSnippet` with web-based implementation.
@available(iOS 14.0, macOS 11.0, *)
public struct TabbyCardView: View {

    private let amount: Double
    private let currency: Currency
    private let lang: Lang
    private let shouldInheritBg: Bool
    private let merchantCode: String

    @State private var webCheckoutBaseUrl: String?

    // MARK: Init

    /// Creates a checkout snippet for the checkout page.
    ///
    /// - Parameters:
    ///   - amount: Order total amount
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

    // MARK: Body
    public var body: some View {
        Group {
            if let webCheckoutBaseUrl = webCheckoutBaseUrl {
                TabbyWebWidgetView(
                    htmlContent: html(webCheckoutBaseUrl: webCheckoutBaseUrl),
                    lang: lang,
                    analyticsPrefix: "Checkout Card"
                )
            } else {
                // Waiting for /sdk/config — webapp handles its own shimmer once we know the
                // right regional URL, so nothing native to show here.
                Color.clear
            }
        }
        .onAppear {
            Task { @MainActor in
                webCheckoutBaseUrl = await TabbySDK.shared.sdkConfigService.endpoints(for: currency).webCheckoutBaseUrl
            }
        }
    }

    private func html(webCheckoutBaseUrl: String) -> String {
        let dir = lang == .ar ? "rtl" : "ltr"
        return """
        <!DOCTYPE html>
        <html lang="\(lang.rawValue)" dir="\(dir)">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
            <style>body { margin: 0; padding: 0; }</style>
        </head>
        <body>
            <div id="tabbyCard"></div>
            <script src="\(webCheckoutBaseUrl)/tabby-card.js"></script>
            <script>
                new TabbyCard({
                    selector: '#tabbyCard',
                    currency: '\(currency.rawValue)',
                    price: \(Int(amount)),
                    lang: '\(lang.rawValue)',
                    publicKey: '\(TabbySDK.shared.apiKey)',
                    merchantCode: '\(merchantCode)',
                    shouldInheritBg: \(shouldInheritBg)
                });
            </script>
        </body>
        </html>
        """
    }
}

#if DEBUG
@available(iOS 14.0, macOS 11.0, *)
struct TabbyCardView_Previews: PreviewProvider {
    static var previews: some View {
        TabbySDK.shared.setup(withApiKey: "pk_test_abc")

        return VStack(spacing: 20) {
            TabbyCardView(
                amount: 1000,
                currency: .SAR,
                lang: .en,
                merchantCode: "SA"
            )

            TabbyCardView(
                amount: 1000,
                currency: .SAR,
                lang: .ar,
                merchantCode: "SA"
            )
            .environment(\.layoutDirection, .rightToLeft)
        }
        .padding()
    }
}
#endif
