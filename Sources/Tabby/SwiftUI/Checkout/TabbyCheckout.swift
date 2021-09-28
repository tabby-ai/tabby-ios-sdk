//
//  TabbyCheckout.swift
//  Tabby
//
//  Created by ilya.kuznetsov on 26.08.2021.
//

import SwiftUI

@available(iOS 13.0, *)
struct ActivityIndicator: UIViewRepresentable {
    
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

@available(iOS 13.0, *)
struct CheckoutView: View {
    @ObservedObject var checkout: TabbyCheckoutViewModel
    
    func checkForProducts () {
        if let s = checkout.session {
            for type in s.configuration.availableProducts.keys {
                switch type {
                case "installments":
                    guard let products = s.configuration.availableProducts["installments"] else {
                        checkout.installmentsURL = ""
                        break
                    }
                    guard let product = products.first else {
                        checkout.installmentsURL = ""
                        break
                    }
                    guard let webUrl = product.webUrl as String? else {
                        checkout.installmentsURL = ""
                        break
                    }
                    checkout.installmentsURL = webUrl
                    checkout.installmentsButtonEnabled = true
                    
                case "pay_later":
                    guard let products = s.configuration.availableProducts["pay_later"] else {
                        checkout.payLaterURL = ""
                        break
                        
                    }
                    guard let product = products.first else {
                        checkout.payLaterURL = ""
                        break
                    }
                    guard let webUrl = product.webUrl as String? else {
                        checkout.payLaterURL = ""
                        break
                    }
                    checkout.payLaterURL = webUrl
                    checkout.paylaterButtonEnabled = true
                default:
                    continue
                }
            }
        }
    }
    
    var body: some View {
        return NavigationView {
            VStack{
                if checkout.session == nil {
                    ActivityIndicator(isAnimating: .constant(true), style: .medium)
                }
                VStack {
                    NavigationLink(
                        destination: CheckoutWebView(
                            type: .public,
                            productType: .installments,
                            url: checkout.installmentsURL,
                            vc: checkout
                        )) {
                        HStack {
                            Text("Pay in installments")
                                .font(.headline)
                                .foregroundColor(checkout.installmentsButtonEnabled ? .black : .white)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .frame(minWidth: 150, idealWidth: 150)
                        .background(checkout.installmentsButtonEnabled ? Color("Tabby") : Color(.gray))
                        .cornerRadius(8)
                    }
                    .disabled(!checkout.installmentsButtonEnabled)
                    
                    NavigationLink(
                        destination: CheckoutWebView(
                            type: .public,
                            productType: .payLater,
                            url: checkout.payLaterURL,
                            vc: checkout
                        )) {
                        HStack {
                            Text("Pay later with Tabby")
                                .font(.headline)
                                .foregroundColor(checkout.paylaterButtonEnabled ? .black : .white)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .frame(minWidth: 150, idealWidth: 150)
                        .background(checkout.paylaterButtonEnabled ? Color("Tabby") : Color(.gray))
                        .cornerRadius(8)
                    }
                    .disabled(!checkout.paylaterButtonEnabled)
                }
                
            }.onAppear(perform: {
                checkForProducts()
            }).navigationBarTitle("Tabby")
        }
        
    }
}

@available(iOS 13.0, *)
public struct TabbyCheckout: View {
    @StateObject var checkout = TabbyCheckoutViewModel()
    
    var apiKey: String
    var payload: TabbyCheckoutPayload
    var completion: (TabbyResult) -> ()
    
    func createCheckoutSession() {
        if checkout.session != nil {
            return
        }
        checkout.pending = true
        Api.shared.createSession(payload: payload, apiKey: apiKey, completed: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let s):
                    checkout.session = s
                    checkout.pending = false
                case .failure(let error):
                    print(error.localizedDescription)
                    checkout.pending = false
                }
            }
        })
    }
    
    public var body: some View {
        HStack {
            if checkout.pending {
                ActivityIndicator(isAnimating: .constant(true), style: .medium)
            } else {
                CheckoutView(checkout: checkout)
            }
        }
        .valueChanged(value: checkout.result, onChange: { val in
            guard let v = val else {
                return
            }
            completion(v)
        })
        .onAppear() {
            createCheckoutSession()
        }
    }
}

