//
//  CheckoutSession.swift
//  Tabby
//
//  Created by ilya.kuznetsov on 26.08.2021.
//

import Foundation

struct CheckoutSession: Codable {
    var id: String
    var configuration: Configuration
    var payment: CheckoutPayment
}

struct CheckoutPayment: Codable {
    var id: String
}

struct Configuration: Codable {
    var availableProducts: [String: [Product]]
    
    enum CodingKeys: String, CodingKey {
        case availableProducts = "available_products"
    }
}


struct Product: Codable {
    var webUrl: String
    
    enum CodingKeys: String, CodingKey {
        case webUrl = "web_url"
    }
}

public enum TabbyResult: String {
    case close = "close"
    case authorized = "authorized"
    case rejected = "rejected"
    case expired = "expired"
}

public enum TabbyProductType: String, Codable {
    case installments = "installments"
    case pay_later = "pay_later"
}

public struct TabbyCheckoutPayload: Codable {
    public let merchant_code: String
    public let lang: Lang
    public let payment: Payment
    
    public init(merchant_code: String, lang: Lang, payment: Payment) {
        self.merchant_code = merchant_code
        self.lang = lang
        self.payment = payment
    }
}

struct PaymentResult: Decodable {
    var status: PaymentStatus
    
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
    var status: String
    var payment: PaymentResult
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case payment = "payment"
    }
}
