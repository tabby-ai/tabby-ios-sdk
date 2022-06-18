//
//  CheckoutLink.swift
//  
//
//  Created by Dmitrii Ziablikov on 03.06.2022.
//

import Foundation

// MARK: - CheckoutLink

public enum CheckoutLink {
    
    // MARK: - CheckoutData

    struct CheckoutData {
        
        // MARK: - Internal Properties

        let amount: Double
        let currency: Currency
        let splitPeriod: SplitPeriod
    }
    
    // MARK: - CheckoutType

    enum CheckoutType {
        
        // MARK: - Types

        case installments(Lang)
        case creditCardInstallments(Lang)
    }

    // MARK: - Static Methods

    static func link(for type: CheckoutType, data: CheckoutData? = nil) -> String {
        var link = "https://checkout.tabby.ai"
        
        switch type {
        case let .installments(lang):
            link += "/promos/product-page/installments/\(lang.rawValue)/"
        case let .creditCardInstallments(lang):
            link += "/promos/checkout-page/credit-card-installments/\(lang.rawValue)/"
        }
        
        if let data = data {
            return "\(link)?price=\(data.amount)&currency=\(data.currency.rawValue)&splitPeriod=\(data.splitPeriod.rawValue)"
        } else {
            return link
        }
    }
}
