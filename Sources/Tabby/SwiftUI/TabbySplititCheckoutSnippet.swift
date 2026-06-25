//
//  SwiftUIView.swift
//  
//
//  Created by ilya.kuznetsov on 19.01.2022.
//

import SwiftUI

@available(*, deprecated, renamed: "TabbySnippetView", message: "Use TabbySnippetView instead")
@available(iOS 14.0, macOS 11, *)
public struct TabbySplititCheckoutSnippet: View {
    @Environment(\.layoutDirection) var direction
    @State private var isOpened: Bool = false
    @State private var webCheckoutBaseUrl: String?

    private let analyticsService = AnalyticsService.shared

    func toggleOpen() -> Void {
        isOpened.toggle()
    }

    let amount: Double
    let currency: Currency
    let withCurrencyInArabic: Bool
    let splitPeriod: Int
    var urls: (String, String) = ("", "")

    private var overwritenURL: String?
    private var pageURL: String? {
        if let overwritenURL = overwritenURL {
            return overwritenURL
        }
        guard let baseUrl = webCheckoutBaseUrl else { return nil }
        let path = isRTL ? "/promos/checkout-page/credit-card-installments/ar/" : "/promos/checkout-page/credit-card-installments/en/"
        return "\(baseUrl)\(path)?price=\(amount)&currency=\(currency.rawValue)&splitPeriod=\(splitPeriod)"
    }
    
    private var isRTL: Bool {
        direction == .rightToLeft
    }
    
    private var pageLang: Lang {
        isRTL ? .ar : .en
    }
    
    public init(
        amount: Double,
        currency: Currency,
        url: String? = nil,
        splitPeriod: SplitPeriod = .of4,
        preferCurrencyInArabic: Bool? = nil
    ) {
        self.amount = amount
        self.currency = currency
        self.withCurrencyInArabic = preferCurrencyInArabic ?? false
        self.splitPeriod = splitPeriod.rawValue

        if let url {
          self.overwritenURL = url
        }
    }
    
    private var learnMoreText: String {
        String(format: "learnMore".localized)
    }
    
    private var remainingHeld: String {
        String(format: "remainingHeld".localized)
    }
    
    private var chargedToday: String {
        String(format: "chargedToday".localized)
    }
    
    private var noFeesText: String {
        String(format: "noFeesCreditCard".localized)
    }

    public var body: some View {
        ZStack {
          VStack(alignment: .leading) {
            HStack(alignment: .top) {
              VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 16) {
                  Text(noFeesText)
                    .foregroundColor(textPrimaryColor)
                    .font(.footnote)
                  
                  HStack {
                    VStack(alignment: .leading, spacing: 4) {
                      Text(chargedToday)
                        .foregroundColor(textPrimaryColor)
                        .font(.footnote)
                        .bold()
                        
                        Text(String.moneyString(
                            from: amount/Double(splitPeriod),
                            currency: currency,
                            locale: withCurrencyInArabic || isRTL ? .ar : .en
                        ))
                        .foregroundColor(textPrimaryColor)
                        .tabbyStyle(.interBody)
                      
                    }
                    VStack(alignment: .leading, spacing: 4) {
                      Text(remainingHeld)
                        .foregroundColor(textPrimaryColor)
                        .font(.footnote)
                        .bold()
                    
                      Text(String.moneyString(
                            from: amount/Double(splitPeriod) * (Double(splitPeriod) - 1),
                            currency: currency,
                            locale: withCurrencyInArabic || isRTL ? .ar : .en
                        ))
                        .foregroundColor(textPrimaryColor)
                        .tabbyStyle(.interBody)
                    }
                  }
                  
                  HStack(spacing: 4) {
                    Text(learnMoreText)
                      .foregroundColor(iris300Color)
                      .font(.footnote)
                      .bold()
                      .underline()
                  }
                }
                
              }
              .frame(minWidth: 0,
                     maxWidth: .infinity,
                     minHeight: 0,
                     alignment: .leading)
            }
          }
          .background(Color(.white))
          .padding(.horizontal, 16)
          .onTapGesture {
              guard pageURL != nil else { return }
              analyticsService.send(event: .LearnMore.clicked(currency: currency, installmentsCount: splitPeriod))
              toggleOpen()
          }
        }
        .sheet(isPresented: $isOpened, onDismiss: {
            analyticsService.send(event: .LearnMore.popUpClosed(currency: currency, installmentsCount: splitPeriod))
        }, content: {
          if let pageURL = pageURL {
              SafariView(urlString: pageURL)
                .onAppear(perform: {
                    analyticsService.send(event: .LearnMore.popUpOpened(currency: currency, installmentsCount: splitPeriod))
                })
          }
        })
        .onAppear {
            resolveEndpoints()
            analyticsService.send(event: .SnippedCard.rendered(currency: currency, installmentsCount: splitPeriod))
        }
        // Currency picks the geo-sharded host, so a currency change must re-resolve the base URL (MPC-2731).
        .onChange(of: currency) { _ in resolveEndpoints() }
    }

    private func resolveEndpoints() {
        Task { @MainActor in
            webCheckoutBaseUrl = await TabbySDK.shared.sdkConfigService.endpoints(for: currency).webCheckoutBaseUrl
        }
    }
}

@available(iOS 14.0, macOS 11, *)
struct TabbySplititCheckoutSnippetPreview: PreviewProvider {
  static var previews: some View {
    VStack {
      Group {
        Text("SplitPeriod :: default (4)")
          TabbySplititCheckoutSnippet(amount: 1990, currency: .AED)
              .border(.black)
        TabbySplititCheckoutSnippet(amount: 1990, currency: .AED, preferCurrencyInArabic: true)
              .border(.black)
      }
      Group {
        Text("SplitPeriod :: default (6)")
        TabbySplititCheckoutSnippet(amount: 1990, currency: .AED, splitPeriod: .of6)
              .border(.black)
        TabbySplititCheckoutSnippet(
          amount: 1990,
          currency: .AED,
          splitPeriod: .of6,
          preferCurrencyInArabic: true)
        .border(.black)
      }
    }
  }
}
