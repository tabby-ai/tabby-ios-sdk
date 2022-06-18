//
//  APIError.swift
//  Tabby
//
//  Created by ilya.kuznetsov on 26.08.2021.
//

import Foundation

// MARK: - APIError (Error)

public enum APIError: Error {
    
    // MARK: - Types

    case invalidUrl
    case invalidResponse
    case noResponse
    case invalidData
    case parsingError
    case unableToComplete
    case internalError
    case serverError
}
