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

struct TabbyCheckoutPayload: Codable {
    let merchant_code: String
    let lang: Lang
    let payment: Payment
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
