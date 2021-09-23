//
//  TabbyPresentationSnippet.swift
//  TabbyDemo
//
//  Created by ilya.kuznetsov on 12.09.2021.
//

import SwiftUI

let SPACE = " "

@available(iOS 13.0, macOS 11, *)
public struct TabbyPresentationSnippet: View {
    @State private var isOpened: Bool = false

    func toggleOpen() -> Void {
        isOpened.toggle()
    }

    let amount: Double
    let currency: Currency
    let lang: Lang

    public init(amount: Double, currency: Currency, lang: Lang) {
        self.amount = amount
        self.currency = currency
        self.lang = lang
    }


    public var body: some View {
        let isRTL = lang == Lang.ar
        let titleEN = STRINGS_EN["presentation"]!
        let titleAR = STRINGS_AR["presentation"]!
        let noInterest = STRINGS_AR["noInterest"]!
        let learnMore = !isRTL ? STRINGS_EN["learnMore"]! : STRINGS_AR["learnMore"]!

        return ZStack {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        if(!isRTL) {
                            Text("\(titleEN)\(SPACE)\(amount/4, specifier: "%.2f")\(SPACE)\(currency.rawValue)\(SPACE)")
                                .foregroundColor(textPrimaryColor)
                                .font(.footnote)
                                + Text(learnMore)
                                .foregroundColor(textPrimaryColor)
                                .font(.footnote)
                                .underline()
                        } else {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("\(titleAR)")
                                        .foregroundColor(textPrimaryColor)
                                        .font(.footnote)
                                    Text("\(SPACE)\(amount/4, specifier: "%.2f")\(SPACE)\(currency.rawValue)")
                                        .foregroundColor(textPrimaryColor)
                                        .font(.footnote)
                                }
                                .padding(.bottom, 1)
                                HStack(alignment: .lastTextBaseline) {
                                    Text("\(noInterest)")
                                        .foregroundColor(textPrimaryColor)
                                        .font(.footnote)
                                    Text(learnMore)
                                        .foregroundColor(textPrimaryColor)
                                        .font(.footnote)
                                        .underline()
                                }
                            }
                        }
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

@available(iOS 14.0, macOS 11, *)
struct TabbyPresentationSnippet_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TabbyPresentationSnippet(amount: 1990, currency: .SAR, lang: Lang.en)
                .preferredColorScheme(.light)
            TabbyPresentationSnippet(amount: 1990, currency: .SAR, lang: Lang.ar)
                .preferredColorScheme(.light)
                .environment(\.layoutDirection, .rightToLeft)
        }
    }
}
