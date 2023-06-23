//
//  CheckoutSession.swift
//  Tabby
//
//  Created by ilya.kuznetsov on 26.08.2021.
//

import Foundation

struct CheckoutSession: Codable {
    var id: String
//    var warnings: [TabbyWarning]?
    var configuration: Configuration
    var payment: CheckoutPayment
//    var rejectionReasonCode: String?
//    var status: TabbyStatus
    
    enum CodingKeys: String, CodingKey {
        case id
//        case warnings
        case configuration
        case payment
//        case rejectionReasonCode = "rejection_reason_code"
//        case status
    }
}

public enum TabbyStatus: String, Codable {
    case created = "created"
    case approved = "approved"
    case rejected = "rejected"
    case expired = "expired"
}

struct CheckoutPayment: Codable {
    var id: String
}

struct Configuration: Codable {
    var availableProducts: [String: [AvailableProduct]]
//    var products: [String: [Product]]
    
    enum CodingKeys: String, CodingKey {
        case availableProducts = "available_products"
//        case products
    }
}

//struct Product: Codable {
//    var type: TabbyProductType
//    var isAvailable: Bool
//    var rejectionReason: String
//    enum CodingKeys: String, CodingKey {
//        case isAvailable = "is_available"
//        case type
//        case rejectionReason = "rejection_reason"
//    }
//}

struct AvailableProduct: Codable {
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

public enum TabbyProductType: String, Codable, CaseIterable {
    case installments = "installments"
    case creditCardInstallments = "credit_card_installments"
    case monthlyBilling = "monthly_billing"
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
    case created = "created"
}

struct CreatedCheckoutSession: Decodable {
    var status: String
    var payment: PaymentResult
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case payment = "payment"
    }
}

struct TabbyWarning: Codable {
    var field: String
    var code: String
    var message: String
    var name: String
}
