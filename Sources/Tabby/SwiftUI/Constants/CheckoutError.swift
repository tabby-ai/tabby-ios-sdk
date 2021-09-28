//
//  CheckoutError.swift
//  Tabby
//
//  Created by ilya.kuznetsov on 26.08.2021.
//

import Foundation

enum CheckoutError: Error {
    case invalidUrl
    case invalidResponse
    case invalidData
    case unableToComplete
}

let TEST_API_KEY = "pk_test_17ec8568-1cbf-4827-8479-088e5438432a"
