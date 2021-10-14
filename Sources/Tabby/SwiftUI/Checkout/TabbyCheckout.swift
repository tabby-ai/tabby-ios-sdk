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

public class TabbySDK {
    public typealias SessionCompletion = Result<(sessionId: String, tabbyProductTypes: [TabbyProductType]), CheckoutError>
    
    public static var shared = TabbySDK()
    
    fileprivate var apiKey: String = ""
    fileprivate var session: CheckoutSession?
    
    public func setup(withApiKey apiKey: String) {
        self.apiKey = apiKey
    }
    
    public func configure(forPayment payload: TabbyCheckoutPayload, completion: @escaping (SessionCompletion) -> ()) {
        Api.shared.createSession(payload: payload, apiKey: TabbySDK.shared.apiKey, completed: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let s):
                    self.session = s
                    var tabbyProductTypes: [TabbyProductType] = []
                    
                    if s.configuration.availableProducts["installments"] != nil {
                        tabbyProductTypes.append(.installments)
                    }
                    if s.configuration.availableProducts["pay_later"] != nil {
                        tabbyProductTypes.append(.pay_later)
                    }
                    let res: (sessionId: String, tabbyProductTypes: [TabbyProductType]) = (
                        sessionId: s.id,
                        tabbyProductTypes: tabbyProductTypes
                    )
                    completion(.success(res))
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            
        })
    }
}

@available(iOS 13.0, *)
public struct TabbyCheckout: View {
    @StateObject var checkout = TabbyCheckoutViewModel()
    
    public var productType: TabbyProductType
    public var onResult: (TabbyResult) -> ()
    
    init(productType: TabbyProductType, onResult: @escaping (TabbyResult) -> ()) {
        self.productType = productType
        self.onResult = onResult
    }
    
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
                    break
                }
            }
        }
    }
    
    public var body: some View {
        HStack {
            if(productType == .installments) {
                CheckoutWebView(
                    type: .public,
                    productType: .installments,
                    url: self.checkout.installmentsURL,
                    vc: self.checkout
                )
            } else if (productType == .pay_later) {
                CheckoutWebView(
                    type: .public,
                    productType: .payLater,
                    url: self.checkout.payLaterURL,
                    vc: self.checkout
                )
            } else {
                ActivityIndicator(isAnimating: .constant(true), style: .medium)
            }
        }
        .valueChanged(value: checkout.result, onChange: { val in
            guard let v = val else {
                return
            }
            onResult(v)
        })
        .onAppear() {
            if let s = TabbySDK.shared.session {
                checkout.session = s
                self.checkForProducts()
            }
        }
    }
}

