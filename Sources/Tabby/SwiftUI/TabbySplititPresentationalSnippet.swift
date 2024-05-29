//
//  SwiftUIView.swift
//  
//
//  Created by ilya.kuznetsov on 19.01.2022.
//

import SwiftUI

@available(iOS 13.0, macOS 11, *)
public struct TabbyCreditCardInstallmentsSnippet: View {
    @Environment(\.layoutDirection) var direction
    @State private var isOpened: Bool = false

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
    private var pageURL: String {
        if let overwritenURL {
            return overwritenURL
        }
        
        let baseURL = isRTL ? WebViewBaseURL.Splitit.ar : WebViewBaseURL.Splitit.en
        return "\(baseURL)?price=\(amount)&currency=\(currency.rawValue)&splitPeriod=\(splitPeriod)"
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
        self.splitPeriod = Int(splitPeriod.rawValue)

        if let url {
            self.overwritenURL = url
        }
    }
    
    private var learnMoreText: String {
        String(format: "learnMore".localized)
    }
    
    private var titleText: String {
        String(format: "snippetTitleCreditCard".localized, "\((amount/Double(splitPeriod)).withFormattedAmount)", "\(currency.localized(l: withCurrencyInArabic ? .ar : nil))")
    }

    // MARK: - BODY
    public var body: some View {
        ZStack {
          VStack(alignment: .leading) {
            HStack(alignment: .top) {
              VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 4) {
                  Text(titleText)
                    .foregroundColor(textPrimaryColor)
                    .font(.system(size: 12))
                  + Text(learnMoreText)
                    .foregroundColor(iris300Color)
                    .font(.system(size: 12, weight: .bold))
                    .underline()
                }
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       minHeight: 0,
                       alignment: .leading)
              }
              Logo()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color(.white))
            .cornerRadius(8)
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 3, x: 0, y: 2)
            .padding(.horizontal, 16)
            .environment(\.layoutDirection, isRTL ? .rightToLeft : .leftToRight)
            .onTapGesture {
                analyticsService.send(event: .LearnMore.clicked(currency: currency, installmentsCount: splitPeriod))
                toggleOpen()
            }
          }
          .sheet(isPresented: $isOpened, onDismiss: {
              analyticsService.send(event: .LearnMore.popUpClosed(currency: currency, installmentsCount: splitPeriod))
          }, content: {
            SafariView(lang: pageLang, customUrl: pageURL)
              .onAppear(perform: {
                  analyticsService.send(event: .LearnMore.popUpOpened(currency: currency, installmentsCount: splitPeriod))
              })
          })
        }
        .onAppear(perform: {
            analyticsService.send(event: .SnippedCard.rendered(currency: currency, installmentsCount: splitPeriod))
        })
    }
}

@available(iOS 13.0, *)
struct TabbyCreditCardInstallmentsSnippetPreview: PreviewProvider {
  static var previews: some View {
    VStack{
      TabbyCreditCardInstallmentsSnippet(amount: 1990, currency: .SAR)
    }
  }
}
