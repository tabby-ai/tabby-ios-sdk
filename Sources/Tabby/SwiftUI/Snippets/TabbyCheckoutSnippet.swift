//
//  InstallmentSnippetView.swift
//  Tabby
//
//  Created by ilya.kuznetsov on 22.08.2021.
//

import SwiftUI

public struct TabbyCheckoutSnippet: View {
    
    @Environment(\.layoutDirection) private var direction
    
    let amount: Double
    let currency: Currency
    let withCurrencyInArabic: Bool
    
    private let noFeesText = "noFees".localized
    private let todayText = "today".localized
    private let in1MonthText = "in1Month".localized
    private let in2MonthsText = "in2Months".localized
    private let in3MonthsText = "in3Months".localized
    private var isRTL = false
    private var chunkAmount = ""
    
    public init(amount: Double, currency: Currency, preferCurrencyInArabic: Bool? = nil) {
        self.amount = amount
        self.currency = currency
        self.withCurrencyInArabic = preferCurrencyInArabic ?? false
        self.isRTL = direction == .rightToLeft
        self.chunkAmount = !isRTL
        ? "\((amount / 4).withFormattedAmount) \(currency.rawValue)"
        : "\(currency.localized(l: withCurrencyInArabic && isRTL ? .ar : nil)) \((amount / 4).withFormattedAmount)"
    }
    
    public var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text(noFeesText)
                    .foreground(.textSecondary())
                    .font(.footnote)
                    .padding(.horizontal, 4)
                
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                    Color(red: 172/255, green: 172/255, blue: 182/255, opacity: 1)
                        .frame(width: .infinity, height: 1)
                        .padding(.top, 19)
                    
                    HStack {
                        ForEach(0..<StaticImage.allCases.filter({ $0 != .logo }).count, id: \.self) { index in
                            let staticImage = StaticImage.allCases[index]
                            
                            VStack(alignment: .center) {
                                HStack(spacing: 1) {
                                    DividerLine(visible: false)
                                    
                                    AsyncImage(
                                        url: URL(string: staticImage.link),
                                        placeholder: {
                                            RoundedRectangle(cornerRadius: 20)
                                                .foregroundColor(.gray)
                                                .frame(width: 40, height: 40)
                                        }, result: {
                                            Image(uiImage: $0)
                                                .resizable()
                                        }
                                    )
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .rotationEffect(.degrees(staticImage.degrees(isRTL)))
                                    
                                    DividerLine(visible: true)
                                }
                                .frame(width: .infinity, height: 40, alignment: .center)
                                
                                Text(chunkAmount)
                                    .modifier(AmountTextStyle())
                                
                                Text(todayText)
                                    .modifier(DateTextStyle())
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            
                            Spacer()
                        }
                    }
                }
                .padding(.top, 16)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
            .background(Color(.white))
            .padding(.horizontal, 16)
            .environment(\.layoutDirection, isRTL ? .rightToLeft : .leftToRight)
        }
    }
}

struct DividerLine: View {
    var visible: Bool
    
    var body: some View {
        Color(red: 172/255, green: 172/255, blue: 182/255, opacity: 1)
            .frame(width: .infinity, height: visible ? 1 : 0)
            .padding(.top,  -1)
    }
}

struct InstallmentSnippetView_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            TabbyCheckoutSnippet(amount: 1000, currency: .aed)
            TabbyCheckoutSnippet(amount: 350, currency: .aed)
                .environment(\.layoutDirection, .rightToLeft)
            TabbyCheckoutSnippet(amount: 350, currency: .aed, preferCurrencyInArabic: true)
                .environment(\.layoutDirection, .rightToLeft)
        }
        .preferredColorScheme(.light)
    }
}
