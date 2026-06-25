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
    
    public var symbol: String {
        switch self {
        case .AED: return "AED"
        case .SAR: return "\u{20cf}"
        case .KWD: return "KWD"
        case .BHD: return "BHF"
        case .QAR: return "QAR"
        }
    }
    
    public func localized(l: Lang?) -> String {
        if (l == nil || l == .en) {
            return self.symbol
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

/// Lets `Currency` be used directly as a `Dictionary` key in `Codable` payloads — keyed JSON
/// objects (e.g. `{"SAR": {...}, "AED": {...}}`) decode straight into `[Currency: Value]`
/// on iOS 15.4+ without a custom container.
@available(iOS 15.4, macOS 12.3, *)
extension Currency: CodingKeyRepresentable {
    public var codingKey: any CodingKey {
        rawValue.codingKey
    }

    public init?<T: CodingKey>(codingKey: T) {
        self.init(rawValue: codingKey.stringValue)
    }
}

