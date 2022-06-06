//
//  Currency.swift
//  
//
//  Created by ilya.kuznetsov on 30.08.2021.
//

import Foundation

public enum Currency: String, Codable {
    case aed = "AED"
    case sar = "SAR"
    case bhd = "BHD"
    case kwd = "KWD"
    case egp = "EGP"
    
    public func localized(l: Lang?) -> String {
        if l == nil || l == .en { return rawValue }
        
        switch self {
        case .aed:
            return "د.إ"
        case .sar:
            return "ر.س"
        case .bhd:
            return "د.ب"
        case .kwd:
            return "د.ك"
        case .egp:
            return "جنيه"
        }
    }
}
