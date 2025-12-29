import SwiftUI

// MARK: - Tabby Card (Checkout Snippet)

@available(iOS 14.0, macOS 11.0, *)
public struct TabbyCardView: View {

    private let amount: Double
    private let currency: Currency
    private let lang: Lang
    private let shouldInheritBg: Bool
    private let merchantCode: String

    // MARK: Init
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
        let price = Int(amount)
        let queryParams: [String: String] = [
            "price": "\(price)",
            "currency": currency.rawValue,
            "lang": lang.rawValue,
            "publicKey": TabbySDK.shared.apiKey,
            "merchantCode": merchantCode,
            "shouldInheritBg": "\(shouldInheritBg)"
        ]

        return TabbyWebWidgetView(
            widgetURL: BaseURL.WebView.Widgets.card,
            queryParams: queryParams,
            lang: lang,
            analyticsPrefix: "Checkout Card"
        )
    }
}

#if DEBUG
@available(iOS 14.0, macOS 11.0, *)
struct TabbyCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            TabbyCardView(
                amount: 1600.00,
                currency: .SAR,
                lang: .en,
                merchantCode: "SA"
            )

            TabbyCardView(
                amount: 1200.00,
                currency: .AED,
                lang: .ar,
                merchantCode: "AE"
            )
            .environment(\.layoutDirection, .rightToLeft)
        }
        .padding()
    }
}
#endif
