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
        
        let textNode1 = String(format: "snippetTitle1".localized)
        let textNode2 = String(format: "snippetAmount".localized, "\((amount/4).withFormattedAmount)", "\(currency.localized(l: withCurrencyInArabic && isRTL ? .ar : nil))")
        let textNode3 = String(format: "snippetTitle2".localized)
        
        let learnMoreText = String(format: "learnMore".localized)
        
        return ZStack {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text(textNode1)
                            .foregroundColor(textPrimaryColor)
                            .font(.system(size: 14))
                        + Text(textNode2)
                            .foregroundColor(textPrimaryColor)
                            .font(.system(size: 14, weight: .bold))
                        + Text(textNode3)
                            .foregroundColor(textPrimaryColor)
                            .font(.system(size: 14))
                        + Text(learnMoreText)
                            .foregroundColor(textPrimaryColor)
                            .font(.system(size: 14))
                            
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
            .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(borderColor, lineWidth: 1)
                )
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
        .preferredColorScheme(.light)
    }
}
