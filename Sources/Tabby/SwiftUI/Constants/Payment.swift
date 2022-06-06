//
//  Payment.swift
//  Tabby
//
//  Created by ilya.kuznetsov on 26.08.2021.
//

import Foundation

public struct Buyer: Codable {
    public let email: String
    public let phone: String
    public let name: String
    public let dob: String?
    
    public init(email: String, phone: String, name: String, dob: String? = nil) {
        self.email = email
        self.phone = phone
        self.name = name
        self.dob = dob
    }
}

public struct OrderItem: Codable {
    public let description: String // 'To be displayed in tabby order information'
    public let product_url: String // https://tabby.store/p/SKU123
    public let quantity: Int // 1
    public let reference_id: String // 'SKU123'
    public let title: String // 'Sample Item #1'
    public let unit_price: String // '300'
    public let category: String // jeans / dress / shorts
    
    public init(
        description: String,
        product_url: String,
        quantity: Int,
        reference_id: String,
        title: String,
        unit_price: String,
        category: String
    ) {
        self.description = description
        self.product_url = product_url
        self.quantity = quantity
        self.reference_id = reference_id
        self.title = title
        self.unit_price = unit_price
        self.category = category
    }
}

public struct Order: Codable {
    public let reference_id: String // #xxxx-xxxxxx-xxxx
    public let items: [OrderItem]?
    public let shipping_amount: String? // '50'
    public let tax_amount: String? // '500'
    public let discount_amount: String? // '500'
    
    public init(
        reference_id: String,
        items: [OrderItem]? = nil,
        shipping_amount: String? = nil,
        tax_amount: String? = nil,
        discount_amount: String? = nil
    ) {
        self.reference_id = reference_id
        self.items = items
        self.shipping_amount = shipping_amount
        self.tax_amount = tax_amount
        self.discount_amount = discount_amount
    }
}

public enum OrderItemPaymentMethod: String, Codable {
    case card
    case cod
}

public enum OrderItemStatus: String, Codable {
    case new
    case processing
    case complete
    case refunded
    case canceled
    case unknown
}

public struct OrderHistory: Codable {
    public let purchased_at: String // "2019-08-24T14:15:22Z"
    public let amount: String // "10.00"
    public let payment_method: OrderItemPaymentMethod
    public let status: OrderItemStatus
    public let buyer: Buyer
    public let items: [OrderItem]
    public let shipping_address: ShippingAddress
    
    public init(
        purchased_at: String,
        amount: String,
        payment_method: OrderItemPaymentMethod,
        status: OrderItemStatus,
        buyer: Buyer,
        items: [OrderItem],
        shipping_address: ShippingAddress
    ) {
        self.purchased_at = purchased_at
        self.amount = amount
        self.payment_method = payment_method
        self.status = status
        self.buyer = buyer
        self.items = items
        self.shipping_address = shipping_address
    }
}

public struct ShippingAddress: Codable {
    public let address: String
    public let city: String
    
    public init(address: String, city: String) {
        self.address = address
        self.city = city
    }
}

public struct BuyerHistory: Codable {
    public let registered_since: String // "2019-08-24T14:15:22Z"
    public let loyalty_level: Int // 0
    public let wishlist_count: Int // 0
    public let is_social_networks_connected: Bool // true
    public let is_phone_number_verified: Bool // true
    public let is_email_verified: Bool // true
    
    public init(
        registered_since: String,
        loyalty_level: Int,
        wishlist_count: Int,
        is_social_networks_connected: Bool,
        is_phone_number_verified: Bool,
        is_email_verified: Bool
    ) {
        self.registered_since = registered_since
        self.loyalty_level = loyalty_level
        self.wishlist_count = wishlist_count
        self.is_social_networks_connected = is_social_networks_connected
        self.is_phone_number_verified = is_phone_number_verified
        self.is_email_verified = is_email_verified
    }
}

public struct Payment: Codable {
    public let amount: String
    public let currency: Currency
    public let description: String
    public let buyer: Buyer
    public let buyer_history: BuyerHistory?
    public let order: Order?
    public let order_history: [OrderHistory]?
    public let shipping_address: ShippingAddress?
    
    public init(
        amount: String,
        currency: Currency,
        description: String,
        buyer: Buyer,
        buyer_history: BuyerHistory? = nil,
        order: Order? = nil,
        order_history: [OrderHistory]? = nil,
        shipping_address: ShippingAddress? = nil
    ) {
        self.amount = amount
        self.currency = currency
        self.description = description
        self.buyer = buyer
        self.buyer_history = buyer_history
        self.order = order
        self.order_history = order_history
        self.shipping_address = shipping_address
    }
}
