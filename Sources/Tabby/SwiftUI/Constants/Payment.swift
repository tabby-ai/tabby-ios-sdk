//
//  Payment.swift
//  Tabby
//
//  Created by ilya.kuznetsov on 26.08.2021.
//

import Foundation

struct Buyer: Codable {
    let email: String
    let phone: String
    let name: String
    let dob: String?
}

struct OrderItem: Codable {
    let description: String // 'To be displayed in tabby order information'
    let product_url: String // https://tabby.store/p/SKU123
    let quantity: Int // 1
    let reference_id: String // 'SKU123'
    let title: String // 'Sample Item #1'
    let unit_price: String // '300'
}

struct Order: Codable {
    let reference_id: String // #xxxx-xxxxxx-xxxx
    let items: [OrderItem]?
    let shipping_amount: String? // '50'
    let tax_amount: String? // '500'
}

struct ShippingAddress: Codable {
    let address: String
    let city: String
}

struct Payment: Codable {
    let amount: String
    let currency: Currency
    let description: String
    let buyer: Buyer
    let order: Order?
    let shipping_address: ShippingAddress?
}
