//
//  TabbyPresentationSnippet.swift
//  TabbyDemo
//
//  Created by ilya.kuznetsov on 12.09.2021.
//

import SwiftUI

public struct TabbyProductPageSnippet: View {
    
    @Environment(\.layoutDirection) private var direction
    @State private var isOpened = false
    
    private let amount: Double
    private let currency: Currency
    private let withCurrencyInArabic: Bool
    private let textNode1 = "snippetTitle1".localized
    private let textNode3 = "snippetTitle2".localized
    private let learnMoreText = "learnMore".localized
    private var textNode2 = ""
    private var isRTL = false
    
    public init(amount: Double, currency: Currency, preferCurrencyInArabic: Bool? = nil) {
        self.amount = amount
        self.currency = currency
        self.withCurrencyInArabic = preferCurrencyInArabic ?? false
        self.isRTL = direction == .rightToLeft
        let amountValue = (amount / 4).withFormattedAmount
        let currencyValue = currency.localized(l: withCurrencyInArabic && isRTL ? .ar : nil)
        self.textNode2 = String(format: "snippetAmount".localized, "\(amountValue)", "\(currencyValue)")
    }
    
    public var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text(textNode1)
                            .foregroundColor(Color(.textPrimary()))
                            .font(.system(size: 14))
                        + Text(textNode2)
                            .foregroundColor(Color(.textPrimary()))
                            .font(.system(size: 14, weight: .bold))
                        + Text(textNode3)
                            .foregroundColor(Color(.textPrimary()))
                            .font(.system(size: 14))
                        + Text(learnMoreText)
                            .foregroundColor(Color(.textPrimary()))
                            .font(.system(size: 14))
                            .underline()
                        
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .leading)
                    
                    AsyncImage(
                        url: URL(string: StaticImage.logo.link),
                        placeholder: {
                            Rectangle()
                                .foreground(.tabby())
                                .frame(width: 70, height: 28)
                                .cornerRadius(4)
                        }, result: {
                            Image(uiImage: $0)
                                .resizable()
                        }
                    )
                        .scaledToFit()
                        .background(.tabby())
                        .frame(width: 70, height: 28)
                        .cornerRadius(4)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color(.white))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.border()), lineWidth: 1)
            )
            .padding(.horizontal, 16)
            .environment(\.layoutDirection, isRTL ? .rightToLeft : .leftToRight)
            .onTapGesture {
                isOpened.toggle()
            }

        }
        .sheet(isPresented: $isOpened) {
            SafariView(lang: isRTL ? .ar : .en)
        }
    }
}

struct TabbyProductPageSnippet_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TabbyProductPageSnippet(amount: 1990, currency: .sar)
            
            TabbyProductPageSnippet(amount: 1990, currency: .sar)
                .environment(\.layoutDirection, .rightToLeft)
                .environment(\.locale, Locale(identifier: "ar"))
            
            TabbyProductPageSnippet(amount: 1990, currency: .sar, preferCurrencyInArabic: true)
                .environment(\.layoutDirection, .rightToLeft)
                .environment(\.locale, Locale(identifier: "ar"))
        }
        .preferredColorScheme(.light)
    }
}
