//
//  StaticImage.swift
//  TabbyDemo
//
//  Created by ilya.kuznetsov on 12.09.2021.
//

import Foundation

// MARK: - StaticImage

public enum StaticImage: CaseIterable {
    
    // MARK: - Types

    case logo
    case circle1
    case circle2
    case circle3
    case circle4
    
    // MARK: - Internal Properties

    var link: String {
        switch self {
        case .logo:
            return "https://cdn.tabby.ai/assets/logoimg.png"
        case .circle1:
            return "https://cdn.tabby.ai/assets/R1-black.png"
        case .circle2:
            return "https://cdn.tabby.ai/assets/R2-black.png"
        case .circle3:
            return "https://cdn.tabby.ai/assets/R3-black.png"
        case .circle4:
            return "https://cdn.tabby.ai/assets/R4-black.png"
        }
    }
    
    func degrees(_ isRTL: Bool) -> Double {
        switch self {
        case .logo:
            return .zero
        case .circle1:
            return isRTL ? 90 : 0
        case .circle2:
            return isRTL ? 180 : 0
        case .circle3:
            return isRTL ? -90 : 0
        case .circle4:
            return isRTL ? 90 : 0
        }
    }
}
