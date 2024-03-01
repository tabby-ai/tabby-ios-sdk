import Foundation

// MARK: - AnalyticsEvent

/// A struct that represents an event that should be sent to the analytics service.
public struct AnalyticsEvent {

    public let id: String
    public let payload: [String: String]?

    public init(id: String, payload: [String: String]?) {
        self.id = id
        self.payload = payload
    }
}

// MARK: - Events

extension AnalyticsEvent {
    
    
    enum SnippedCard {
        
        /// Snippet Card Rendered
        static func rendered(
            currency: Currency,
            installmentsCount: Int
        ) -> AnalyticsEvent {
            AnalyticsEvent(
                id: "Snippet Card Rendered",
                payload: [
                    "planSelected": String(installmentsCount),
                    "merchantCountry": currency.countryName,
                    "snippetType": "fullInformation"
                ]
            )
        }
    }
    
    enum LearnMore {
        
        /// Learn More Clicked
        static func clicked(
            currency: Currency,
            installmentsCount: Int
        ) -> AnalyticsEvent {
            AnalyticsEvent(
                id: "Learn More Clicked",
                payload: [
                    "merchantIntegrationType": "snippetAndPopup",
                    "planSelected": String(installmentsCount),
                    "snippetType": "fullInformation",
                    "merchantCountry": currency.countryName
                ]
            )
        }
        
        /// Learn More Pop Up Opened
        static func popUpOpened(
            currency: Currency,
            installmentsCount: Int
        ) -> AnalyticsEvent {
            AnalyticsEvent(
                id: "Learn More Pop Up Opened",
                payload: [
                    "merchantIntegrationType": "snippetAndPopup",
                    "planSelected": String(installmentsCount),
                    "popupType": "standardWithInfo",
                    "merchantCountry": currency.countryName
                ]
            )
        }
        
        /// Learn More Pop Up Closed
        static func popUpClosed(
            currency: Currency,
            installmentsCount: Int
        ) -> AnalyticsEvent {
            AnalyticsEvent(
                id: "Learn More Pop Up Closed",
                payload: [
                    "merchantIntegrationType": "snippetAndPopup",
                    "planSelected": String(installmentsCount),
                    "popupType": "standardWithInfo",
                    "merchantCountry": currency.countryName
                ]
            )
        }
    }
}
