import Foundation

/// Region-specific base URLs returned by `POST /api/v1/sdk/config`.
///
/// The backend returns a JSON object whose top-level keys are currency codes (ISO 4217) plus
/// a `general` fallback block. The SDK picks the block matching the merchant's currency and
/// falls back to `general` when no match exists.
struct SdkConfig: Equatable {

    struct Endpoints: Decodable, Equatable {
        let checkoutApiBaseUrl: String
        let webCheckoutBaseUrl: String
        let widgetsBaseUrl: String
        let analyticsBaseUrl: String
    }

    /// The backend nests endpoints under `endpoints` to leave room for future per-region
    /// fields (feature flags, region metadata, etc.).
    struct Region: Decodable, Equatable {
        let endpoints: Endpoints
    }

    static let generalKey = "general"

    let general: Region?
    let perCurrency: [Currency: Region]

    /// Returns endpoints for the given currency, falling back to the `general` block, then to
    /// the hardcoded production fallback — so callers always get a usable URL even from a
    /// broken response.
    func endpoints(for currency: Currency) -> Endpoints {
        if let match = perCurrency[currency]?.endpoints {
            return match
        }
        if let fallback = general?.endpoints {
            return fallback
        }
        return .fallback
    }

    /// Hardcoded fallback used before `/sdk/config` returns or when the request fails.
    /// Picks production or staging hosts based on the merchant-selected environment so the
    /// fallback path stays inside the right environment too.
    static var `default`: SdkConfig {
        SdkConfig(
            general: Region(endpoints: .fallback),
            perCurrency: [:]
        )
    }
}

extension SdkConfig: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode([String: Region].self)

        var general: Region?
        var perCurrency: [Currency: Region] = [:]
        for (key, region) in raw {
            if key == Self.generalKey {
                general = region
            } else if let currency = Currency(rawValue: key) {
                perCurrency[currency] = region
            }
            // Unknown keys are intentionally ignored so the backend can ship new currencies
            // without breaking older SDK builds.
        }
        self.general = general
        self.perCurrency = perCurrency
    }
}
