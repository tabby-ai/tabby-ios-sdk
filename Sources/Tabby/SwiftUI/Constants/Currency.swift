//
//  Currency.swift
//  
//
//  Created by ilya.kuznetsov on 30.08.2021.
//

import Foundation

public enum Currency: String, Codable {
  case AED = "AED"
  case SAR = "SAR"
  case BHD = "BHD"
  case KWD = "KWD"
  
  public func localized(l: Lang?) -> String {
    if (l == nil || l == .en) {
      return self.rawValue
    }
    switch self {
      case .AED:
        return "د.إ"
      case .SAR:
        return "ر.س"
      case .BHD:
        return "د.ب"
      case .KWD:
        return "د.ك"
    }
  }
}
