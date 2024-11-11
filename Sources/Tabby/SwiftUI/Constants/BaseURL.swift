//
//  BaseURL.swift
//  Tabby
//
//

import Foundation

public enum BaseURL {
    
    static var checkout: String = "https://api.tabby.ai/api/v2/checkout"
    static var analyticsURL: String = "https://dp-event-collector.tabby.ai/v1/t"

    public enum WebView {
    
        public enum Tabby {
            static let en = "https://checkout.tabby.ai/promos/product-page/installments/en/"
            static let ar = "https://checkout.tabby.ai/promos/product-page/installments/ar/"
        }
        
        public enum Splitit {
            static let en = "https://checkout.tabby.ai/promos/checkout-page/credit-card-installments/en/"
            static let ar = "https://checkout.tabby.ai/promos/checkout-page/credit-card-installments/ar/"
        }
    }
}
