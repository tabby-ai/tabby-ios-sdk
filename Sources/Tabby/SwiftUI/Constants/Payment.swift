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
}

struct Payment: Codable {
    let amount: String
    let currency: Currency
    let buyer: Buyer
}
