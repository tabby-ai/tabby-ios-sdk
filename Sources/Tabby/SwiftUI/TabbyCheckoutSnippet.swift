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
    
    private var isRTL: Bool { direction == .rightToLeft }
    
    private enum DividerVisibility {
        case none
        case leading
        case trailing
        case full
    }
    
    private enum Segment {
        case q25
        case q50
        case q75
        case q100
        
        func circleView(isRTL: Bool) -> some View {
            switch self {
            case .q25:
                return SegmentedCircle(state: .q25)
                    .rotationEffect(.degrees(isRTL ? 90 : 0))
            case .q50:
                return SegmentedCircle(state: .q50)
                    .rotationEffect(.degrees(isRTL ? 180 : 0))
            case .q75:
                return SegmentedCircle(state: .q75)
                    .rotationEffect(.degrees(isRTL ? -90 : 0))
            case .q100:
                return SegmentedCircle(state: .q100)
                    .rotationEffect(.degrees(isRTL ? 90 : 0))
            }
        }
    }
    
    public init(amount: Double, currency: Currency, preferCurrencyInArabic: Bool? = nil) {
        self.amount = amount
        self.currency = currency
        self.withCurrencyInArabic = preferCurrencyInArabic ?? false
    }
    
    private func chunkView(
        chunkAmount: Double,
        todayText: String,
        segment: Segment,
        dividerVisibility: DividerVisibility = .full
    ) -> some View {
        let chunkAmountText = !isRTL
        ? Text("\(chunkAmount/4, specifier: "%.2f") \(currency.rawValue)")
        : Text("\(currency.localized(l: withCurrencyInArabic && isRTL ? .ar : nil)) \(chunkAmount/4, specifier: "%.2f") ")
        
        return VStack(alignment: .center, spacing: 6) {
            HStack(spacing: 1) {
                DividerLine(visible: dividerVisibility == .full || dividerVisibility == .trailing)
                segment.circleView(isRTL: isRTL)
                DividerLine(visible: dividerVisibility == .full || dividerVisibility == .leading)
            }
            .frame(height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .frame(maxWidth: .infinity)
            .background(Color(.white))
            
            chunkAmountText
                .tabbyStyle(.captionBold
                    .monospaced()
                )
                .multilineTextAlignment(.center)
            
            Text(todayText)
                .tabbyStyle(.caption
                    .withColor(textSecondaryUIColor)
                )
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
    
    public var body: some View {
        let noFeesText = String(format: "useAnyCard".localized)
        let todayText = String(format: "today".localized)
        let in1MonthText = String(format: "in1Month".localized)
        let in2MonthsText = String(format: "in2Months".localized)
        let in3MonthsText = String(format: "in3Months".localized)
        
        return ZStack {
            VStack(alignment: .leading) {
                Text(noFeesText)
                    .foregroundColor(textSecondaryColor)
                    .tabbyStyle(.body)
                    .padding(.horizontal, 4)
                
                ZStack (alignment: Alignment(horizontal: .center, vertical: .top)) {
                    Color(red: 172/255, green: 172/255, blue: 182/255, opacity: 1)
                        .frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                        .padding(.top, 20 - 1)
                    
                    HStack(alignment: .top) {
                        chunkView(
                            chunkAmount: amount,
                            todayText: todayText,
                            segment: .q25,
                            dividerVisibility: .leading
                        )
                        
                        Spacer()
                        
                        chunkView(
                            chunkAmount: amount,
                            todayText: in1MonthText,
                            segment: .q50
                        )
                        
                        Spacer()
                        
                        chunkView(
                            chunkAmount: amount,
                            todayText: in2MonthsText,
                            segment: .q75
                        )
                        
                        Spacer()
                        
                        chunkView(
                            chunkAmount: amount,
                            todayText: in3MonthsText,
                            segment: .q100,
                            dividerVisibility: .trailing
                        )
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
            .background(Color(.white))
            .padding(.horizontal, 16)
            .environment(\.layoutDirection, isRTL ? .rightToLeft : .leftToRight)
        }
    }
}

@available(iOS 13.0, macOS 11, *)
struct DividerLine: View {
    var visible: Bool
    
    var body: some View {
        Color(red: 172/255, green: 172/255, blue: 182/255, opacity: 1)
            .frame(maxWidth: .infinity, minHeight: visible ? 1 : 0, maxHeight: visible ? 1 : 0)
            .padding(.top,  -1)
    }
}

@available(iOS 13.0, macOS 11, *)
struct InstallmentSnippetView_Preview: PreviewProvider {
    static var previews: some View {
                
        return VStack{
            TabbyCheckoutSnippet(amount: 1000, currency: .AED)
            TabbyCheckoutSnippet(amount: 350, currency: .AED)
                .environment(\.layoutDirection, .rightToLeft)
            TabbyCheckoutSnippet(amount: 350, currency: .AED, preferCurrencyInArabic: true)
                .environment(\.layoutDirection, .rightToLeft)
        }
        .preferredColorScheme(.light)
    }
}
