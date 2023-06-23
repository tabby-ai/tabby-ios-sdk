//
//  TabbyCheckout.swift
//  Tabby
//
//  Created by ilya.kuznetsov on 26.08.2021.
//

import SwiftUI

public final class TabbySDK {
    public typealias SessionCompletion = (sessionId: String, paymentId: String, tabbyProductTypes: [TabbyProductType])
    
    public static var shared = TabbySDK()
    
    fileprivate var apiKey: String = ""
    fileprivate var env: Env = .prod
    fileprivate var session: CheckoutSession?
    
    public func setup(withApiKey apiKey: String, forEnv env: Env = .prod) {
        self.apiKey = apiKey
        self.env = env
    }
    
    public func configure(forPayment payload: TabbyCheckoutPayload) async throws -> SessionCompletion {
        
        do {
            let response = try await Api.shared.createSession(
                payload: payload,
                apiKey: TabbySDK.shared.apiKey,
                env: env
            )
            let tabbyProductTypes = TabbyProductType.allCases.filter { item in
                response.configuration.availableProducts[item.rawValue] != nil && response.status != .rejected && !(response.warnings ?? []).isEmpty
            }
            return (
                sessionId: response.id,
                paymentId: response.payment.id,
                tabbyProductTypes: tabbyProductTypes
            )
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
}

@available(iOS 13.0, *)
public struct TabbyCheckout: View {
    @ObservedObject var checkout = TabbyCheckoutViewModel()
    
    public var productType: TabbyProductType
    public var onResult: (TabbyResult) -> ()
    
    public init(productType: TabbyProductType, onResult: @escaping (TabbyResult) -> ()) {
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
                    
                case "credit_card_installments":
                    guard let products = s.configuration.availableProducts["credit_card_installments"] else {
                        checkout.creditCardInstallmentsURL = ""
                        break
                        
                    }
                    guard let product = products.first else {
                        checkout.creditCardInstallmentsURL = ""
                        break
                    }
                    guard let webUrl = product.webUrl as String? else {
                        checkout.creditCardInstallmentsURL = ""
                        break
                    }
                    checkout.creditCardInstallmentsURL = webUrl
                    
                default:
                    break
                }
            }
        }
    }
    
    public var body: some View {
        HStack {
            if productType == .installments {
                CheckoutWebView(
                    productType: .installments,
                    url: self.checkout.installmentsURL,
                    vc: self.checkout
                )
            } else if productType == .creditCardInstallments {
                CheckoutWebView(
                    productType: .creditCardInstallments,
                    url: self.checkout.creditCardInstallmentsURL,
                    vc: self.checkout
                )
            }
            else {
                ActivityIndicator(style: .medium)
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

