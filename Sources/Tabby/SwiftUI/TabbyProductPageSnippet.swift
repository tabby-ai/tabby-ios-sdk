//
//  TabbyPresentationSnippet.swift
//  TabbyDemo
//
//  Created by ilya.kuznetsov on 12.09.2021.
//

import SwiftUI

@available(iOS 14.0, macOS 11, *)
public struct TabbyProductPageSnippet: View {
    @State private var isOpened: Bool = false
    @Environment(\.layoutDirection) var direction
    
    private let analyticsService = AnalyticsService.shared
    
    func toggleOpen() -> Void {
        isOpened.toggle()
    }
    
    let amount: Double
    let currency: Currency
    let withCurrencyInArabic: Bool
    
    private let installmentsCount = 4
    
    private var isRTL: Bool {
        direction == .rightToLeft
    }
    
    private var pageURL: String {
        let baseURL = isRTL ? WebViewBaseURL.Tabby.ar : WebViewBaseURL.Tabby.en
        return "\(baseURL)?price=\(amount)&currency=\(currency.rawValue)&source=sdk"
    }
    
    private var pageLang: Lang {
        isRTL ? .ar : .en
    }
    
    public init(amount: Double, currency: Currency, preferCurrencyInArabic: Bool? = nil) {
        self.amount = amount
        self.currency = currency
        self.withCurrencyInArabic = preferCurrencyInArabic ?? false
    }
    
    public var body: some View {
        let textNode1 = String(format: "snippetTitle1".localized)
        let textNode2 = String(format: "snippetAmount".localized, "\((amount/Double(installmentsCount)).withFormattedAmount)", "\(currency.localized(l: withCurrencyInArabic && isRTL ? .ar : nil))")
        let textNode3 =  String(format: "snippetTitle2".localized)
        
        let learnMoreText = String(format: "learnMore".localized)
        
        return ZStack {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text(textNode1)
                            .tabbyStyle(.interBody)
                        + Text(textNode2)
                            .tabbyStyle(.interBodyBold)
                        + Text(textNode3)
                            .tabbyStyle(.interBody)
                        + Text(learnMoreText)
                            .tabbyStyle(.interBody)
                        
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
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: 1)
            )
            
            .padding(.horizontal, 16)
            .environment(\.layoutDirection, isRTL ? .rightToLeft : .leftToRight)
            .onTapGesture {
                analyticsService.send(event: .LearnMore.clicked(currency: currency, installmentsCount: installmentsCount))
                toggleOpen()
            }
        }
        .sheet(isPresented: $isOpened, onDismiss: {
            analyticsService.send(event: .LearnMore.popUpClosed(currency: currency, installmentsCount: installmentsCount))
        }, content: {
            SafariView(lang: pageLang, customUrl: pageURL)
                .onAppear(perform: {
                    analyticsService.send(event: .LearnMore.popUpOpened(currency: currency, installmentsCount: installmentsCount))
                })
        })
        .onAppear(perform: {
            analyticsService.send(event: .SnippedCard.rendered(currency: currency, installmentsCount: installmentsCount))
        })
    }
}


// MARK: - PREVIEW

@available(iOS 14.0, macOS 11, *)
struct TabbyProductPageSnippet_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TabbyProductPageSnippet(amount: 1990, currency: .QAR)
            
            TabbyProductPageSnippet(amount: 1990, currency: .AED)
            
            TabbyProductPageSnippet(amount: 1990, currency: .QAR)
                .environment(\.layoutDirection, .rightToLeft)
                .environment(\.locale, Locale(identifier: "ar"))
            
            TabbyProductPageSnippet(amount: 1990, currency: .SAR, preferCurrencyInArabic: true)
                .environment(\.layoutDirection, .rightToLeft)
                .environment(\.locale, Locale(identifier: "ar"))
        }
        .preferredColorScheme(.light)
    }
}
