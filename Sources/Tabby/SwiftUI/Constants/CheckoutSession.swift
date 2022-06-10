//
//  CheckoutSession.swift
//  Tabby
//
//  Created by ilya.kuznetsov on 26.08.2021.
//

import Foundation

public struct CheckoutSession: Codable {
    let id: String
    let configuration: Configuration
    let payment: CheckoutPayment
}

struct CheckoutPayment: Codable {
    let id: String
}

struct Configuration: Codable {
    let availableProducts: [String: [Product]]
    
    enum CodingKeys: String, CodingKey {
        case availableProducts = "available_products"
    }
}

struct Product: Codable {
    let webUrl: String
    
    enum CodingKeys: String, CodingKey {
        case webUrl = "web_url"
    }
}

public enum TabbyState: String {
    case close
    case authorized
    case created
    case rejected
    case expired
}

public enum TabbyProductType: String, Codable, CaseIterable {
    case installments = "installments"
    case payLater = "pay_later"
    case creditCardInstallments = "credit_card_installments"
    
    enum CodingKeys: String, CodingKey {
        case installments = "installments"
        case payLater = "pay_later"
        case creditCardInstallments = "credit_card_installments"
    }
}

public struct TabbyCheckoutPayload: Codable {
    public let merchantCode: String
    public let lang: Lang
    public let payment: Payment
    
    public init(merchantCode: String, lang: Lang, payment: Payment) {
        self.merchantCode = merchantCode
        self.lang = lang
        self.payment = payment
    }
    
    enum CodingKeys: String, CodingKey {
        case merchantCode = "merchant_code"
        case lang = "lang"
        case payment = "payment"
    }
}

struct PaymentResult: Decodable {
    let status: PaymentStatus
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
    }
}

enum PaymentStatus: String, Decodable {
    case authorized = "authorized"
    case rejected = "rejected"
    case closed = "closed"
    case created = "CREATED"
}

struct CreatedCheckoutSession: Decodable {
    let status: String
    let payment: PaymentResult
}
