//
//  SwiftUIView.swift
//  
//
//  Created by ilya.kuznetsov on 19.01.2022.
//

import SwiftUI

public struct TabbyCreditCardInstallmentsSnippet: View {
    
    @Environment(\.layoutDirection) private var direction
    @State private var isOpened = false
    
    private let amount: Double
    private let currency: Currency
    private let withCurrencyInArabic: Bool
    private let splitPeriod: Int
    private let learnMore = "learnMore".localized
    private var isRTL = false
    private var title = ""
    private var urls: (english: String, arabic: String) = ("", "")
    
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
        let amountValue = (amount / 4).withFormattedAmount
        let currencyValue = currency.localized(l: withCurrencyInArabic && isRTL ? .ar : nil)
        self.title = String(format: "snippetTitleCreditCard".localized, "\(amountValue)", "\(currencyValue)")
    }
    
    public var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(title)
                                .font(.system(size: 12))
                                .foregroundColor(Color(.tabby()))
                            + Text(learnMore)
                                .font(.system(size: 12, weight: .bold))
                                .underline()
                                .foregroundColor(Color(.iris300()))
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .leading)
                    }
                    
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
                        .frame(width: 70, height: 28)
                        .background(.tabby())
                        .cornerRadius(4)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(Color(.white))
                .cornerRadius(8)
                .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 3, x: 0, y: 2)
                .padding(.horizontal, 16)
                .environment(\.layoutDirection, isRTL ? .rightToLeft : .leftToRight)
                .onTapGesture {
                    isOpened.toggle()
                }
            }
            .sheet(isPresented: $isOpened) {
                SafariView(lang: isRTL ? .ar : .en, customUrl: isRTL ? urls.arabic : urls.english)
            }
        }
    }
}

struct TabbyCreditCardInstallmentsSnippetPreview: PreviewProvider {
    static var previews: some View {
        VStack {
            TabbyCreditCardInstallmentsSnippet(amount: 1990, currency: .sar)
        }
    }
}
