//
//  SwiftUIView.swift
//  
//
//  Created by ilya.kuznetsov on 19.01.2022.
//

import SwiftUI

@available(iOS 14.0, macOS 11, *)
public struct TabbyCreditCardInstallmentsSnippet: View {
  @Environment(\.layoutDirection) var direction
  @State private var isOpened: Bool = false
  
  func toggleOpen() -> Void {
    isOpened.toggle()
  }
  
  let amount: Double
  let currency: Currency
  let withCurrencyInArabic: Bool
  let splitPeriod: Int?
  var urls: (String, String) = ("", "")
  
  public init(
    amount: Double,
    currency: Currency,
    url: String? = nil,
    splitPeriod: SplitPeriod? = .of4,
    preferCurrencyInArabic: Bool? = nil
  ) {
    self.amount = amount
    self.currency = currency
    self.withCurrencyInArabic = preferCurrencyInArabic ?? false
    self.splitPeriod = Int(splitPeriod!.rawValue)
    
    if let passedUrl = url {
      self.urls = (passedUrl, passedUrl)
    } else {
      let urlEn =  "\(splititWebViewUrls[.en]!)?price=\(amount)&currency=\(currency.rawValue)&splitPeriod=\(Int(splitPeriod!.rawValue))"
      let urlAr =  "\(splititWebViewUrls[.ar]!)?price=\(amount)&currency=\(currency.rawValue)&splitPeriod=\(Int(splitPeriod!.rawValue))"
      self.urls = (urlEn, urlAr)
    }
  }
  
  // MARK: - BODY
  public var body: some View {
    let isRTL = direction == .rightToLeft
    let title = String(format: "snippetTitleCreditCard".localized, "\((amount/4).withFormattedAmount)", "\(currency.localized(l: withCurrencyInArabic && isRTL ? .ar : nil))")
    let learnMore = String(format: "learnMore".localized)
    
    return ZStack {
      VStack(alignment: .leading) {
        HStack(alignment: .top) {
          VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 4) {
              Text(title)
                .foregroundColor(textPrimaryColor)
                .font(.system(size: 12))
              + Text(learnMore)
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
          toggleOpen()
        }
      }
      .sheet(isPresented: $isOpened, content: {
        SafariView(lang: isRTL ? Lang.ar : Lang.en, customUrl: isRTL ? self.urls.1 : self.urls.0)
      })
    }
  }
}

@available(iOS 14.0, *)
struct TabbyCreditCardInstallmentsSnippetPreview: PreviewProvider {
  static var previews: some View {
    VStack{
      TabbyCreditCardInstallmentsSnippet(amount: 1990, currency: .SAR)
    }
  }
}
