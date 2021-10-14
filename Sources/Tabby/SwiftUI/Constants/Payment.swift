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
}

public struct OrderItem: Codable {
    public let description: String // 'To be displayed in tabby order information'
    public let product_url: String // https://tabby.store/p/SKU123
    public let quantity: Int // 1
    public let reference_id: String // 'SKU123'
    public let title: String // 'Sample Item #1'
    public let unit_price: String // '300'
}

public struct Order: Codable {
    public let reference_id: String // #xxxx-xxxxxx-xxxx
    public let items: [OrderItem]?
    public let shipping_amount: String? // '50'
    public let tax_amount: String? // '500'
}

public struct ShippingAddress: Codable {
    public let address: String
    public let city: String
}

public struct Payment: Codable {
    public let amount: String
    public let currency: Currency
    public let description: String
    public let buyer: Buyer
    public let order: Order?
    public let shipping_address: ShippingAddress?
}
