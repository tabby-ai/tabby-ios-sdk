//
//  SwiftUIView.swift
//  
//
//  Created by ilya.kuznetsov on 19.01.2022.
//

import SwiftUI

public struct TabbySplititCheckoutSnippet: View {
    
    @Environment(\.layoutDirection) private var direction
    @State private var isOpened = false
    
    private let amount: Double
    private let currency: Currency
    private let withCurrencyInArabic: Bool
    private let splitPeriod: Int
    private let urls: (english: String, arabic: String)
    private let noFeesText = "noFeesCreditCard".localized
    private let remainingHeld = "remainingHeld".localized
    private let chargedToday = "chargedToday".localized
    private let learnMore = "learnMore".localized
    private var isRTL = false

    
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
        
        if let passedUrl = url {
            self.urls = (passedUrl, passedUrl)
        } else {
            let urlEnglish = CheckoutLink.link(
                for: .creditCardInstallments(.en),
                data: .init(amount: amount, currency: currency, splitPeriod: splitPeriod)
            )
            let urlArabic = CheckoutLink.link(
                for: .creditCardInstallments(.ar),
                data: .init(amount: amount, currency: currency, splitPeriod: splitPeriod)
            )
            self.urls = (urlEnglish, urlArabic)
        }
        
        self.isRTL = direction == .rightToLeft
    }
    
    public var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(noFeesText)
                                .foreground(.textPrimary())
                                .font(.footnote)
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(chargedToday)
                                        .font(.footnote)
                                        .bold()
                                        .foreground(.textPrimary())
                                    if isRTL {
                                        Text("\(currency.rawValue) \(amount/Double(splitPeriod), specifier: "%.2f")")
                                            .foreground(.textPrimary())
                                            .font(.subheadline)
                                    } else {
                                        Text("\(amount/(Double(splitPeriod)), specifier: "%.2f") \(currency.rawValue)")
                                            .foreground(.textPrimary())
                                            .font(.subheadline)
                                    }
                                }
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(remainingHeld)
                                        .font(.footnote)
                                        .bold()
                                        .foreground(.textPrimary())
                                   
                                    if isRTL {
                                        Text("\(currency.rawValue) \(amount / Double(splitPeriod) * (Double(splitPeriod) - 1), specifier: "%.2f")")
                                            .foreground(.textPrimary())
                                            .font(.subheadline)
                                    } else {
                                        Text("\(amount / Double(splitPeriod) * (Double(splitPeriod) - 1), specifier: "%.2f") \(currency.rawValue)")
                                            .font(.subheadline)
                                            .foreground(.textPrimary())
                                    }
                                }
                            }
                            
                            HStack(spacing: 4) {
                                Text(learnMore)
                                    .font(.footnote)
                                    .bold()
                                    .underline()
                                    .foreground(.iris300())
                            }
                        }
                        
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .leading)
                }
            }
            .background(Color(.white))
            .padding(.horizontal, 16)
            .onTapGesture {
                isOpened.toggle()
            }
        }.sheet(isPresented: $isOpened) {
            SafariView(lang: isRTL ? .ar : .en, customUrl: isRTL ? urls.arabic : urls.english)
        }
    }
}

struct TabbySplititCheckoutSnippetPreview: PreviewProvider {
    static var previews: some View {
        VStack {
            Group {
                Text("SplitPeriod :: default (4)")
                TabbySplititCheckoutSnippet(amount: 1990, currency: .aed)
                TabbySplititCheckoutSnippet(amount: 1990, currency: .aed, preferCurrencyInArabic: true)
            }
            Group {
                Text("SplitPeriod :: default (6)")
                TabbySplititCheckoutSnippet(amount: 1990, currency: .aed, splitPeriod: .of6)
                TabbySplititCheckoutSnippet(
                    amount: 1990,
                    currency: .aed,
                    splitPeriod: .of6,
                    preferCurrencyInArabic: true)
            }
        }
    }
}
