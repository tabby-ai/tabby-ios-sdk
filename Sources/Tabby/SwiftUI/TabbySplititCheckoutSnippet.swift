//
//  SwiftUIView.swift
//  
//
//  Created by ilya.kuznetsov on 19.01.2022.
//

import SwiftUI

@available(iOS 13.0, macOS 11, *)
public struct TabbySplititCheckoutSnippet: View {
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
  
  public var body: some View {
    let isRTL = direction == .rightToLeft
    print ("isRTL \(isRTL)")
    let noFeesText = String(format: "noFeesCreditCard".localized)
    let remainingHeld = String(format: "remainingHeld".localized)
    let chargedToday = String(format: "chargedToday".localized)
    let learnMore = String(format: "learnMore".localized)
    
    return ZStack {
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
                  if(isRTL) {
                    Text("\(currency.rawValue) \(amount/Double(splitPeriod!), specifier: "%.2f")")
                      .foregroundColor(textPrimaryColor)
                      .font(.subheadline)
                  } else {
                    Text("\(amount/(Double(splitPeriod!)), specifier: "%.2f") \(currency.rawValue)")
                      .foregroundColor(textPrimaryColor)
                      .font(.subheadline)
                  }
                  
                }
                VStack(alignment: .leading, spacing: 4) {
                  Text(remainingHeld)
                    .foregroundColor(textPrimaryColor)
                    .font(.footnote)
                    .bold()
                  if(isRTL) {
                    Text("\(currency.rawValue) \(amount/Double(splitPeriod!) * (Double(splitPeriod!) - 1), specifier: "%.2f")")
                      .foregroundColor(textPrimaryColor)
                      .font(.subheadline)
                  } else {
                    Text("\(amount/Double(splitPeriod!) * (Double(splitPeriod!) - 1), specifier: "%.2f") \(currency.rawValue)")
                      .foregroundColor(textPrimaryColor)
                      .font(.subheadline)
                  }
                }
              }
              
              HStack(spacing: 4) {
                Text(learnMore)
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
        toggleOpen()
      }
    }
    .sheet(isPresented: $isOpened, content: {
      SafariView(lang: isRTL ? Lang.ar : Lang.en, customUrl: isRTL ? self.urls.1 : self.urls.0)
    })
  }
}

@available(iOS 13.0, macOS 11, *)
struct TabbySplititCheckoutSnippetPreview: PreviewProvider {
  static var previews: some View {
    VStack {
      Group {
        Text("SplitPeriod :: default (4)")
        TabbySplititCheckoutSnippet(amount: 1990, currency: .AED)
        TabbySplititCheckoutSnippet(amount: 1990, currency: .AED, preferCurrencyInArabic: true)
      }
      Group {
        Text("SplitPeriod :: default (6)")
        TabbySplititCheckoutSnippet(amount: 1990, currency: .AED, splitPeriod: .of6)
        TabbySplititCheckoutSnippet(
          amount: 1990,
          currency: .AED,
          splitPeriod: .of6,
          preferCurrencyInArabic: true)
      }
    }
  }
}
