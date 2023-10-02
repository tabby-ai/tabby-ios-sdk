import SwiftUI

/// A type representing attributes applied to the UILabel.
///
/// - Important: Never create this struct directly. Please, use preconfigured static styles and edit them
///
internal struct Typography: Hashable {
    
    private static var fontsIsRegistered: Bool = false
    
    private static func registerFontsIfNeeded() {
        if fontsIsRegistered { return }
        fontsIsRegistered = true
        
        [
            ("Inter-Bold", "ttf"),
            ("Inter-Regular", "ttf"),
            ("Radial-Bold", "otf"),
            ("Radial-Regular", "ttf"),
            ("IBMPlexSansArabic-Regular", "ttf"),
            ("IBMPlexSansArabic-Bold", "ttf")
        ].forEach { name, ext in
            registerFont(name: name, ext: ext)
        }
    }
    
    private static func registerFont(name: String, ext: String) {
        guard let url = TabbySdkBundle.url(forResource: name, withExtension: ext) else {
            print("Could not find font file for: \(name).\(ext)")
            return
        }
        guard let fontDataProvider = CGDataProvider(url: url as CFURL) else {
            print("Could not create font data provider for \(url).")
            return
        }
        guard let font = CGFont(fontDataProvider) else {
            print("could not create font")
            return
        }
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            print(error!.takeUnretainedValue())
        }
    }
    
    /// Actual font applied to the label.
    ///
    /// If `isDynamic` is `true`, this value represents a dynamic font that scales to support Dynamic Type.
    internal let font: UIFont
    
    /// Latin font without dynamic type.
    internal let originalLatinFont: UIFont
    
    /// Arabic font without dynamic type.
    internal let originalArabicFont: UIFont

    /// If `isDynamic` is `true`, font scales to support Dynamic Type.
    ///
    /// Default is `true`.
    internal let isDynamic: Bool

    /// Relative `UIFont.TextStyle` used for Dynamic Type.
    internal let relativeTextStyle: UIFont.TextStyle

    /// Foreground color.
    internal let color: UIColor

    /// Line height used in NSParagraphStyle
    internal let lineHeight: CGFloat

    /// Kerning used in NSParagraphStyle.
    internal let kerning: CGFloat

    /// `NSTextAlignment` used in `NSParagraphStyle`
    ///
    /// Default is `natural`.
    internal let alignment: NSTextAlignment

    /// `NSLineBreakMode` used in `NSParagraphStyle`
    ///
    /// Default is `byWordWrapping`.
    internal let lineBreakMode: NSLineBreakMode
    
    /// Monospaced digits
    internal let monospacedDigits: Bool

    /// Actual font size. Equals `font.pointSize`.
    ///
    /// May differ from the value you set for the font at `init`, if you use Dynamic Type.
    ///
    /// - Important: You don't set this value directly, because this value can be invalid when using Dynamic Type.
    internal var size: CGFloat {
        font.pointSize
    }
    
    internal static var isLatin: Bool {
        UIApplication.shared.userInterfaceLayoutDirection == .leftToRight
    }

    internal static var isArabic: Bool {
        !isLatin
    }

    /// Please, think twice if you call this `init` instead of using preconfigured styles
    internal init(
        arabicFont: UIFont,
        latinFont: UIFont,
        useDynamicFont: Bool = true,
        relativeTextStyle: UIFont.TextStyle,
        color: UIColor,
        lineHeight: CGFloat,
        kerning: CGFloat,
        alignment: NSTextAlignment = .natural,
        lineBreakMode: NSLineBreakMode = .byWordWrapping,
        monospacedDigits: Bool = false
    ) {
        Typography.registerFontsIfNeeded()
        
        originalArabicFont = arabicFont
        originalLatinFont = latinFont
        
        var resultFont = Typography.isLatin ? latinFont : arabicFont
        
        if monospacedDigits {
            let oldFontDescriptor = resultFont.fontDescriptor
            let newFontDescriptor = oldFontDescriptor.monospacedDigitFontDescriptor
            resultFont = UIFont(descriptor: newFontDescriptor, size: resultFont.pointSize)
        }
        
        if useDynamicFont {
            self.font = UIFontMetrics(forTextStyle: relativeTextStyle)
                .scaledFont(for: resultFont)
        } else {
            self.font = resultFont
        }
        isDynamic = useDynamicFont
        self.relativeTextStyle = relativeTextStyle
        self.color = color
        self.lineHeight = lineHeight
        self.kerning = kerning
        self.alignment = alignment
        self.lineBreakMode = lineBreakMode
        self.monospacedDigits = monospacedDigits
    }
}

internal extension Typography {

    /// Creates a copy that supports Dynamic Type.
    func dynamic() -> Self {
        guard !isDynamic else { return self }

        return Typography(
            arabicFont: originalArabicFont,
            latinFont: originalLatinFont,
            useDynamicFont: true,
            relativeTextStyle: relativeTextStyle,
            color: color,
            lineHeight: lineHeight,
            kerning: kerning,
            alignment: alignment,
            lineBreakMode: lineBreakMode,
            monospacedDigits: monospacedDigits
        )
    }

    /// Creates a copy with a different color
    func withColor(_ color: UIColor) -> Self {
        Typography(
            arabicFont: originalArabicFont,
            latinFont: originalLatinFont,
            useDynamicFont: isDynamic,
            relativeTextStyle: relativeTextStyle,
            color: color,
            lineHeight: lineHeight,
            kerning: kerning,
            alignment: alignment,
            lineBreakMode: lineBreakMode,
            monospacedDigits: monospacedDigits
        )
    }

    /// Creates a copy with a different alignment
    func withAlignment(_ alignment: NSTextAlignment) -> Self {
        Typography(
            arabicFont: originalArabicFont,
            latinFont: originalLatinFont,
            useDynamicFont: isDynamic,
            relativeTextStyle: relativeTextStyle,
            color: color,
            lineHeight: lineHeight,
            kerning: kerning,
            alignment: alignment,
            lineBreakMode: lineBreakMode,
            monospacedDigits: monospacedDigits
        )
    }
    
    /// Creates a copy with a monospaced digits
    func monospaced() -> Self {
        Typography(
            arabicFont: originalArabicFont,
            latinFont: originalLatinFont,
            useDynamicFont: isDynamic,
            relativeTextStyle: relativeTextStyle,
            color: color,
            lineHeight: lineHeight,
            kerning: kerning,
            alignment: alignment,
            lineBreakMode: lineBreakMode,
            monospacedDigits: true
        )
    }
}

internal extension Typography {

    typealias Attributes = [NSAttributedString.Key: Any]

    private func paragraphStyle() -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.alignment = alignment
        paragraphStyle.lineBreakMode = lineBreakMode
        return paragraphStyle
    }

    /// Created actual attributes for NSAttributedString
    // TODO: support monospaced digits
    func attributes() -> Attributes {
        [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle(),
            .kern: kerning,

            /// - Important: We set baselineOffset to match rendering box with Figma to make it pixel-perfect.
            /// This is not enough to remove clipping. Use `Label` or `TabbyText` in SwiftUI for that.
            .baselineOffset: (lineHeight - font.lineHeight) / 4.0
        ]
    }
}
