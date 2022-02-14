//
//  TabbyPresentationSnippet.swift
//  TabbyDemo
//
//  Created by ilya.kuznetsov on 12.09.2021.
//

import SwiftUI

@available(iOS 13.0, macOS 11, *)
public struct TabbyProductPageSnippet: View {
  @State private var isOpened: Bool = false
  @Environment(\.layoutDirection) var direction
  
  func toggleOpen() -> Void {
    isOpened.toggle()
  }
  
  let amount: Double
  let currency: Currency
  let withCurrencyInArabic: Bool
  
  public init(amount: Double, currency: Currency, preferCurrencyInArabic: Bool? = nil) {
    self.amount = amount
    self.currency = currency
    self.withCurrencyInArabic = preferCurrencyInArabic ?? false
  }
  
  public var body: some View {
    let isRTL = direction == .rightToLeft
    
    let offerText = String(format: "snippetTitle".localized, "\((amount/4).withFormattedAmount)", "\(currency.localized(l: withCurrencyInArabic && isRTL ? .ar : nil))")
    
    let learnMoreText = String(format: "learnMore".localized)
    return ZStack {
      VStack(alignment: .leading) {
        HStack(alignment: .top) {
          VStack(alignment: .leading) {
            Text(offerText)
              .foregroundColor(textPrimaryColor)
              .font(.system(size: 14))
            + Text(learnMoreText)
              .foregroundColor(iris300Color)
              .font(.system(size: 14, weight: .bold))
              .underline()
            
          }
          .frame(minWidth: 0,
                 maxWidth: .infinity,
                 minHeight: 0,
                 alignment: .leading)
          Logo()
        }
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
      SafariView(lang: isRTL ? Lang.ar : Lang.en)
    })
  }
}


// MARK: - PREVIEW

@available(iOS 13.0, macOS 11, *)
struct TabbyProductPageSnippet_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      TabbyProductPageSnippet(amount: 1990, currency: .SAR)
      
      TabbyProductPageSnippet(amount: 1990, currency: .SAR)
        .environment(\.layoutDirection, .rightToLeft)
        .environment(\.locale, Locale(identifier: "ar"))
      
      TabbyProductPageSnippet(amount: 1990, currency: .SAR, preferCurrencyInArabic: true)
        .environment(\.layoutDirection, .rightToLeft)
        .environment(\.locale, Locale(identifier: "ar"))
    }
    .preferredColorScheme(.dark)
  }
}
