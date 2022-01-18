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
    
    public init(description: String, product_url: String, quantity: Int, reference_id: String, title: String, unit_price: String) {
        self.description = description
        self.product_url = product_url
        self.quantity = quantity
        self.reference_id = reference_id
        self.title = title
        self.unit_price = unit_price
    }
}

public struct Order: Codable {
    public let reference_id: String // #xxxx-xxxxxx-xxxx
    public let items: [OrderItem]?
    public let shipping_amount: String? // '50'
    public let tax_amount: String? // '500'
    
    public init(reference_id: String, items: [OrderItem]?, shipping_amount: String?, tax_amount: String?) {
        self.reference_id = reference_id
        self.items = items
        self.shipping_amount = shipping_amount
        self.tax_amount = tax_amount
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

public struct Payment: Codable {
    public let amount: String
    public let currency: Currency
    public let description: String
    public let buyer: Buyer
    public let order: Order?
    public let shipping_address: ShippingAddress?
    
    public init(amount: String, currency: Currency, description: String, buyer: Buyer, order: Order? = nil, shipping_address: ShippingAddress? = nil) {
        self.amount = amount
        self.currency = currency
        self.description = description
        self.buyer = buyer
        self.order = order
        self.shipping_address = shipping_address
    }
}
