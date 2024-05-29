import Foundation

public enum Currency: String, Codable {
    case AED = "AED"
    case SAR = "SAR"
    case BHD = "BHD"
    case KWD = "KWD"
    case QAR = "QAR"

    public var countryName: String {
        switch self {
        case .AED: return "emirates"
        case .SAR: return "saudi"
        case .KWD: return "kuwait"
        case .BHD: return "bahrain"
        case .QAR: return "qatar"
        }
    }
    
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
        case .QAR:
          return "ر.ق"
        }
    }
}

