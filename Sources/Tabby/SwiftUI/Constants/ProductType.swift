//
//  ProductType.swift
//  Tabby
//
//  Created by ilya.kuznetsov on 26.08.2021.
//

import Foundation

public enum ProductType: String, Decodable {
    case payLater = "pay_later"
    case installments = "installments"
}
