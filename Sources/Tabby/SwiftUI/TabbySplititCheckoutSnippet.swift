//
//  SwiftUIView.swift
//  
//
//  Created by ilya.kuznetsov on 19.01.2022.
//

import SwiftUI

@available(iOS 13.0, macOS 11, *)
public struct TabbySplititCheckoutSnippet: View {
  @State private var isOpened: Bool = false
  
  func toggleOpen() -> Void {
    isOpened.toggle()
  }
  
  let amount: Double
  let currency: Currency
  let lang: Lang
  let url: String?
  
  public init(amount: Double, currency: Currency, lang: Lang, url: String? = nil) {
    self.amount = amount
    self.currency = currency
    self.lang = lang
    self.url = url ?? "\(splititWebViewUrls[lang]!)?price=\(amount)&currency=\(currency.rawValue)"
  }
  
  // MARK: - BODY
  public var body: some View {
    let isRTL = lang == Lang.ar
    let noFees = !isRTL ? STRINGS_EN["noFeesCreditCard"]! : STRINGS_AR["noFeesCreditCard"]!
    let learnMore = !isRTL ? STRINGS_EN["learnMore"]! : STRINGS_AR["learnMore"]!
    
    return ZStack {
      VStack(alignment: .leading) {
        HStack(alignment: .top) {
          VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 16) {
              Text(noFees)
                .foregroundColor(textPrimaryColor)
                .font(.footnote)
              
              HStack {
                VStack(alignment: .leading) {
                  Text("Charged today")
                    .foregroundColor(textPrimaryColor)
                    .font(.footnote)
                    .bold()
                  Text("\(amount/4, specifier: "%.2f") \(currency.rawValue)")
                    .foregroundColor(textPrimaryColor)
                    .font(.subheadline)
                  
                }
                VStack(alignment: .leading) {
                  Text("Remaining held on card")
                    .foregroundColor(textPrimaryColor)
                    .font(.footnote)
                    .bold()
                  Text("\(amount/4*3, specifier: "%.2f") \(currency.rawValue)")
                    .foregroundColor(textPrimaryColor)
                    .font(.subheadline)
                }
              }
              
              HStack(spacing: 4) {
                Text(learnMore)
                  .foregroundColor(iris300Color)
                  .font(.footnote)
                  .bold()
                  .underline()
                Image(systemName: "arrow.up.forward")
                  .resizable()
                  .foregroundColor(iris300Color)
                  .font(Font.system(size: 10, weight: .bold))
                  .frame(width: 10, height: 10)
                
                
              }
            }
            
          }
          .frame(minWidth: 0,
                 maxWidth: .infinity,
                 minHeight: 0,
                 alignment: .leading)
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
      SafariView(lang: isRTL ? Lang.ar : Lang.en, customUrl: self.url)
    })
  }
}

@available(iOS 13.0, macOS 11, *)
struct TabbySplititCheckoutSnippetPreview: PreviewProvider {
  static var previews: some View {
    TabbySplititCheckoutSnippet(amount: 1990, currency: .AED, lang: Lang.en)
  }
}
