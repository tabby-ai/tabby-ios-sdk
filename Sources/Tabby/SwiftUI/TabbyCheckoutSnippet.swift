//
//  InstallmentSnippetView.swift
//  Tabby
//
//  Created by ilya.kuznetsov on 22.08.2021.
//

import SwiftUI

@available(iOS 13.0, macOS 11, *)
public struct TabbyCheckoutSnippet: View {
    @Environment(\.layoutDirection) var direction
    
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
        let noFeesText = String(format: "noFees".localized)
        let todayText = String(format: "today".localized)
        let in1MonthText = String(format: "in1Month".localized)
        let in2MonthsText = String(format: "in2Months".localized)
        let in3MonthsText = String(format: "in3Months".localized)
        
        let chunkAmount = !isRTL
        ? Text("\(amount/4, specifier: "%.2f") \(currency.rawValue)")
        : Text("\(currency.localized(l: withCurrencyInArabic && isRTL ? .ar : nil)) \(amount/4, specifier: "%.2f") ")
        
        return ZStack {
            VStack(alignment: .leading) {
                Text(noFeesText)
                    .foregroundColor(textSecondaryColor)
                    .font(.footnote)
                    .padding(.horizontal, 4)
                
                ZStack (alignment: Alignment(horizontal: .center, vertical: .top)) {
                    Color(red: 172/255, green: 172/255, blue: 182/255, opacity: 1)
                        .frame(width: .infinity, height: 1)
                        .padding(.top, 20 - 1)
                    
                    HStack {
                        VStack(alignment: .center) {
                            HStack(spacing: 1) {
                                Color(red: 172/255, green: 172/255, blue: 182/255, opacity: 1)
                                    .frame(width: .infinity, height: 0)
                                    .padding(.top,  -1)
                                Round1()
                                    .rotationEffect(.degrees(isRTL ? 90 : 0))
                                Color(red: 172/255, green: 172/255, blue: 182/255, opacity: 1)
                                    .frame(width: .infinity, height: 1)
                                    .padding(.top,  -1)
                            }
                            .frame(width: .infinity, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            chunkAmount
                                .bold()
                                .font(.system(size: 11))
                                .padding(.top, 6)
                                .foregroundColor(textPrimaryColor)
                                .multilineTextAlignment(.center)
                            Text(todayText)
                                .bold()
                                .font(.system(size: 11))
                                .foregroundColor(textSecondaryColor)
                                .padding(.top, 4)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        Spacer()
                        VStack(alignment: .center) {
                            HStack(spacing: 1) {
                                Color(red: 172/255, green: 172/255, blue: 182/255, opacity: 1)
                                    .frame(width: .infinity, height: 1)
                                    .padding(.top,  -1)
                                Round2()
                                    .rotationEffect(.degrees(isRTL ? 90 : 0))
                                Color(red: 172/255, green: 172/255, blue: 182/255, opacity: 1)
                                    .frame(width: .infinity, height: 1)
                                    .padding(.top,  -1)
                            }
                            .frame(width: .infinity, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .background(Color(.white))
                            chunkAmount
                                .bold()
                                .font(.system(size: 11))
                                .padding(.top, 6)
                                .multilineTextAlignment(.center)
                                .foregroundColor(textPrimaryColor)
                            Text(in1MonthText)
                                .bold()
                                .font(.system(size: 11))
                                .foregroundColor(textSecondaryColor)
                                .padding(.top, 4)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        Spacer()
                        VStack(alignment: .center) {
                            HStack(spacing: 1) {
                                Color(red: 172/255, green: 172/255, blue: 182/255, opacity: 1)
                                    .frame(width: .infinity, height: 1)
                                    .padding(.top,  -1)
                                Round3()
                                    .rotationEffect(.degrees(isRTL ? 90 : 0))
                                Color(red: 172/255, green: 172/255, blue: 182/255, opacity: 1)
                                    .frame(width: .infinity, height: 1)
                                    .padding(.top,  -1)
                            }
                            .frame(width: .infinity, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .background(Color(.white))
                            .background(Color(.white))
                            chunkAmount
                                .font(.system(size: 11))
                                .bold()
                                .padding(.top, 6)
                                .multilineTextAlignment(.center)
                                
                                .foregroundColor(textPrimaryColor)
                                
                            Text(in2MonthsText)
                                .bold()
                                .font(.system(size: 11))
                                .foregroundColor(textSecondaryColor)
                                .padding(.top, 4)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        Spacer()
                        VStack(alignment: .center) {
                            HStack(spacing: 1) {
                                Color(red: 172/255, green: 172/255, blue: 182/255, opacity: 1)
                                    .frame(width: .infinity, height: 1)
                                    .padding(.top,  -1)
                                Round4()
                                    .rotationEffect(.degrees(isRTL ? 90 : 0))
                                Color(red: 172/255, green: 172/255, blue: 182/255, opacity: 0)
                                    .frame(width: .infinity, height: 1)
                                    .padding(.top,  -1)
                            }
                            .frame(width: .infinity, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .background(Color(.white))
                            chunkAmount
                                .bold()
                                .font(.system(size: 11))
                                .padding(.top, 6)
                                .multilineTextAlignment(.center)
                                .foregroundColor(textPrimaryColor)
                            Text(in3MonthsText)
                                .bold()
                                .font(.system(size: 11))
                                .foregroundColor(textSecondaryColor)
                                .padding(.top, 4)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                    }
                }
                .padding(.top, 16)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
            .background(Color(.white))
//            .cornerRadius(8)
            .padding(.horizontal, 16)
//            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 3, x: 0, y: 2)
            .environment(\.layoutDirection, isRTL ? .rightToLeft : .leftToRight)
        }
    }
}

@available(iOS 13.0, macOS 11, *)
struct InstallmentSnippetView_Preview: PreviewProvider {
    static var previews: some View {
        VStack{
            TabbyCheckoutSnippet(amount: 5000, currency: .AED)
                  TabbyCheckoutSnippet(amount: 350, currency: .AED)
                    .environment(\.layoutDirection, .rightToLeft)
                  TabbyCheckoutSnippet(amount: 350, currency: .AED, preferCurrencyInArabic: true)
                    .environment(\.layoutDirection, .rightToLeft)
        }
        .preferredColorScheme(.light)
//        .previewLayout(.sizeThatFits)
    }
}
