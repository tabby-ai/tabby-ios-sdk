import SwiftUI

let TabbySdkBundle = Bundle.module

public extension String {
    var localized: String {
        NSLocalizedString(self, bundle: TabbySdkBundle, comment: "")
    }
}

extension NumberFormatter {
    
    static let moneyAmountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}

extension String {
    
    static func moneyString(from amount: Double, currency: Currency, locale: Lang = .en) -> String {
        let numberFormatter = NumberFormatter.moneyAmountFormatter
        
        if let formattedAmount = numberFormatter.string(from: NSNumber(value: amount)) {
            return "\u{200E}\(currency.symbol)\u{00A0}\(formattedAmount)"
        } else {
            return String(format: "\u{200E}%@\u{00A0}%.2f", amount, currency.symbol)
        }
    }
}
