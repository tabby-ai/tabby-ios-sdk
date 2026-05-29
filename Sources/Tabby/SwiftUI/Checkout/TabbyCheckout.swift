//
//  TabbyCheckout.swift
//  Tabby
//
//

import SwiftUI

public final class TabbySDK {
    
    public struct SessionCompletionPayload {
        public var sessionId: String
        public var paymentId: String
        public var tabbyProductTypes: [TabbyProductType]
        public var rejectionReason: RejectionReason?
    }
    
    public typealias SessionCompletion = Result<SessionCompletionPayload, CheckoutError>
    
    public static var shared = TabbySDK()
    
    private let analyticsService = AnalyticsService.shared
    
    private(set) var apiKey: String = ""
    fileprivate var session: CheckoutSession?
    
    public func setup(withApiKey apiKey: String) {
        self.apiKey = apiKey
                
        self.analyticsService.baseURL = BaseURL.analyticsURL
        self.analyticsService.setContextItem(
            .tabbySDK(apiKey: apiKey)
        )
    }
    
    public func configure(forPayment payload: TabbyCheckoutPayload, completion: @escaping (SessionCompletion) -> ()) {
        Task {
            let config = await SdkConfigService.shared.config()
            let endpoints = config.endpoints(for: payload.payment.currency)
            Api.shared.createSession(
                payload: payload,
                apiKey: TabbySDK.shared.apiKey,
                baseUrl: endpoints.checkoutApiBaseUrl
            ) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let s):
                        self.session = s
                        var tabbyProductTypes: [TabbyProductType] = []

                        for key in TabbyProductType.allCases {
                            if s.configuration.availableProducts[key.rawValue] != nil {
                                tabbyProductTypes.append(key)
                            }
                        }

                        let res = SessionCompletionPayload(
                            sessionId: s.id,
                            paymentId: s.payment.id,
                            tabbyProductTypes: tabbyProductTypes,
                            rejectionReason: s.status == "rejected" ? s.configuration.products.installments.rejection_reason : nil
                        )
                        completion(.success(res))

                    case .failure(let error):
                        print(error.localizedDescription)
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}

@available(iOS 14.0, *)
public struct TabbyCheckout: View {
    @StateObject var checkout = TabbyCheckoutViewModel()
    
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

                default:
                    break
                }
            }
        }
    }
    
    public var body: some View {
        HStack {
            if (productType == .installments) {
                CheckoutWebView(
                    productType: .installments,
                    url: self.checkout.installmentsURL,
                    vc: self.checkout
                )
            } else {
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

