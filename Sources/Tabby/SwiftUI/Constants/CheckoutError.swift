//
//  CheckoutError.swift
//  Tabby
//
//  Created by ilya.kuznetsov on 26.08.2021.
//

import Foundation

public enum CheckoutError: Error {
    case invalidUrl
    case invalidResponse
    case noResponse
    case invalidData
    case unableToDecode
    case unableToComplete
}
