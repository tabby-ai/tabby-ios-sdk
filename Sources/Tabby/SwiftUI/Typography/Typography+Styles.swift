import UIKit

extension UIFont {
    
    static func customFont(named name: String, ofSize size: CGFloat) -> UIFont {
        UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

internal extension Typography {
    
    /// Inter / Regular / 14
    static var interBody: Typography {
        Typography(
            arabicFont: UIFont.systemFont(ofSize: 14),
            latinFont: UIFont.customFont(named: "Inter-Regular", ofSize: 14),
            relativeTextStyle: .body,
            color: textPrimaryUIColor,
            lineHeight: Typography.isLatin ? 18 : 20,
            kerning: -0.15)
    }
    
    /// Inter / Bold / 14
    static var interBodyBold: Typography {
        Typography(
            arabicFont: UIFont.boldSystemFont(ofSize: 14),
            latinFont: UIFont.customFont(named: "Inter-Bold", ofSize: 14),
            relativeTextStyle: .body,
            color: textPrimaryUIColor,
            lineHeight: Typography.isLatin ? 18 : 20,
            kerning: -0.15)
    }
    
    /// Regular / 14
    static var body: Typography {
        Typography(
            arabicFont: UIFont.customFont(named: "IBMPlexSansArabic-Regular", ofSize: 14),
            latinFont: UIFont.customFont(named: "Radial-Regular", ofSize: 14),
            relativeTextStyle: .body,
            color: textPrimaryUIColor,
            lineHeight: Typography.isLatin ? 18 : 20,
            kerning: -0.15)
    }
    
    /// Bold / 14
    static var bodyBold: Typography {
        Typography(
            arabicFont: UIFont.customFont(named: "IBMPlexSansArabic-Bold", ofSize: 14),
            latinFont: UIFont.customFont(named: "Radial-Bold", ofSize: 14),
            relativeTextStyle: .body,
            color: textPrimaryUIColor,
            lineHeight: Typography.isLatin ? 18 : 20,
            kerning: -0.15)
    }
    
    
    /// Regular / 11
    static var caption: Typography {
        Typography(
            arabicFont: UIFont.customFont(named: "IBMPlexSansArabic-Regular", ofSize: 11),
            latinFont: UIFont.customFont(named: "Radial-Regular", ofSize: 11),
            relativeTextStyle: .caption1,
            color: textSecondaryUIColor,
            lineHeight: Typography.isLatin ? 14 : 16,
            kerning: -0.07)
    }
    
    /// Bold / 11
    static var captionBold: Typography {
        Typography(
            arabicFont: UIFont.customFont(named: "IBMPlexSansArabic-Bold", ofSize: 11),
            latinFont: UIFont.customFont(named: "Radial-Bold", ofSize: 11),
            relativeTextStyle: .caption1,
            color: textSecondaryUIColor,
            lineHeight: Typography.isLatin ? 14 : 16,
            kerning: -0.07)
    }
}
