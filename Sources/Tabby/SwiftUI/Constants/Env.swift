//
//  Env.swift
//  
//
//  Created by ilya.kuznetsov on 13.12.22.
//

import Foundation

public enum Env: String, Codable {
    case stage = "stage"
    case prod = "prod"
}

public enum Constants {
    
    static func checkoutBaseURL(for env: Env) -> String {
        switch env {
        case .stage:
            return "https://api.tabby.dev/api/v2/checkout"
        case .prod:
            return "https://api.tabby.ai/api/v2/checkout"
        }
    }
    
    static func analyticsBaseURL(for env: Env) -> String {
        switch env {
        case .stage:
            return "https://dp-event-collector.tabby.dev/v1/t"
        case .prod:
            return "https://dp-event-collector.tabby.ai/v1/t"
        }
    }
}
