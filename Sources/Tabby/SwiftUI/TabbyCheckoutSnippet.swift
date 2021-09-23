//
//  InstallmentSnippetView.swift
//  Tabby
//
//  Created by ilya.kuznetsov on 22.08.2021.
//

import SwiftUI

@available(iOS 13.0, macOS 11, *)
struct TabbyCheckoutSnippet: View {
    @State private var isOpened: Bool = false
    @Environment(\.layoutDirection) var direction
    
    func toggleOpen() -> Void {
        isOpened.toggle()
    }
    
    let amount: Double
    let currency: Currency
    
    public init(amount: Double, currency: Currency) {
        self.amount = amount
        self.currency = currency
        print(direction)
    }
    
    public var body: some View {
        let isRTL = direction == .rightToLeft
        let title = !isRTL ? STRINGS_EN["title"]! : STRINGS_AR["title"]!
        let noFees = !isRTL ? STRINGS_EN["noFees"]! : STRINGS_AR["noFees"]!
        let chunkAmount = !isRTL
            ? Text("\(amount/4, specifier: "%.2f") \(currency.rawValue)")
            : Text("\(currency.rawValue) \(amount/4, specifier: "%.2f") ")
        
        return ZStack {
            VStack(alignment: .leading) {
                HStack (alignment: .top) {
                    Text("\(title) \(amount/4, specifier: "%.2f") \(currency.rawValue)")
                        .foregroundColor(textPrimaryColor)
                        .font(.subheadline)
                        .frame(width: .infinity)
                    Spacer()
                    Logo()
                }
                Text(noFees)
                    .foregroundColor(textSecondaryColor)
                    .font(.footnote)
                
                ZStack (alignment: Alignment(horizontal: .center, vertical: .top)) {
                    Color(red: 172/255, green: 172/255, blue: 182/255, opacity: 1)
                        .frame(width: .infinity, height: 0.5)
                        .padding(.top, 11)
                    
                    HStack{
                        VStack(alignment: .leading) {
                            ZStack{
                                Round1()
                                    .rotationEffect(.degrees(direction == .rightToLeft ? 90 : 0))
                            }
                            .frame(width: 22, height: 22, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .background(Color(.white))
                            chunkAmount
                                .bold()
                                .font(.system(size: 11))
                                .padding(.top, 16)
                                .foregroundColor(textPrimaryColor)
                            Text(!isRTL ? STRINGS_EN["today"]! : STRINGS_AR["today"]!)
                                .bold()
                                .font(.system(size: 11))
                                .foregroundColor(textSecondaryColor)
                                .padding(.top, 4)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            ZStack {
                                Round2()
                            }
                            .frame(width: 22, height: 22, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .background(Color(.white))
                            chunkAmount
                                .bold()
                                .font(.system(size: 11))
                                .padding(.top, 16)
                                .foregroundColor(textPrimaryColor)
                            Text(!isRTL ? STRINGS_EN["in1Month"]! : STRINGS_AR["in1Month"]!)
                                .bold()
                                .font(.system(size: 11))
                                .foregroundColor(textSecondaryColor)
                                .padding(.top, 4)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            ZStack {
                                Round3()
                                    .rotationEffect(.degrees(direction == .rightToLeft ? -90 : 0))
                            }
                            .frame(width: 22, height: 22, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .background(Color(.white))
                            chunkAmount
                                .bold()
                                .font(.system(size: 11))
                                .padding(.top, 16)
                                .foregroundColor(textPrimaryColor)
                            Text(!isRTL ? STRINGS_EN["in2Months"]! : STRINGS_AR["in2Months"]!)
                                .bold()
                                .font(.system(size: 11))
                                .foregroundColor(textSecondaryColor)
                                .padding(.top, 4)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            ZStack {
                                Round4()
                            }
                            .frame(width: 22, height: 22, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .background(Color(.white))
                            chunkAmount
                                .bold()
                                .font(.system(size: 11))
                                .padding(.top, 16)
                                .foregroundColor(textPrimaryColor)
                            Text(!isRTL ? STRINGS_EN["in3Months"]! : STRINGS_AR["in3Months"]!)
                                .bold()
                                .font(.system(size: 11))
                                .foregroundColor(textSecondaryColor)
                                .padding(.top, 4)
                        }.background(Color(.white))
                    }
                }
                .padding(.top, 24)
                .padding(.horizontal, 4)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
            .background(Color(.white))
            .cornerRadius(8)
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 3, x: 0, y: 2)
            
            .padding(.horizontal, 16)
            .onTapGesture {
                toggleOpen()
            }
        }.sheet(isPresented: $isOpened, content: {
            SafariView(lang: isRTL ? Lang.ar : Lang.en)
//                .ignoresSafeArea(.all)
        })
    }
}

@available(iOS 13.0, macOS 11, *)
struct InstallmentSnippetView_Preview: PreviewProvider {
    static var previews: some View {
        VStack{
            TabbyCheckoutSnippet(amount: 800, currency: .AED)
                .preferredColorScheme(.light)
            
            TabbyCheckoutSnippet(amount: 800, currency: .AED)
                .preferredColorScheme(.light)
                .environment(\.layoutDirection, .rightToLeft)
                .previewDisplayName("Right to Left")
        }
    }
}
