//
//  Palette.swift
//  
//
//  Created by ilya.kuznetsov on 30.08.2021.
//

import Foundation
import SwiftUI

// MARK: - Color ()

public extension Color {
    var tabby: Color { Color(red: 62/255, green: 237/255, blue: 191/255, opacity: 1) }
    var textPrimary: Color { Color(red: 41/255, green: 41/255, blue: 41/255, opacity: 1) }
    var textSecondary: Color { Color(red: 84/255, green: 84/255, blue: 92/255, opacity: 1) }
    var iris300: Color { Color(red: 56/255, green: 53/255, blue: 175/255, opacity: 1) }
    var border: Color { Color(red: 214/255, green: 214/255, blue: 222/255, opacity: 1) }
}

// MARK: - Palette

public enum Palette {

    // MARK: - Types
    
    case clear,
         tabby(_ opacity: Double = 1),
         textPrimary(_ opacity: Double = 1),
         textSecondary(_ opacity: Double = 1),
         iris300(_ opacity: Double = 1),
         border(_ opacity: Double = 1)

    // MARK: - Public Properties
    
    public var suColor: Color {
        switch self {
        case .clear:
            return .clear
        case let .tabby(opacity):
            return Color(.tabby(opacity))
        case let .textPrimary(opacity):
            return Color(.textPrimary(opacity))
        case let .textSecondary(opacity):
            return Color(.textSecondary(opacity))
        case let .iris300(opacity):
            return Color(.iris300(opacity))
        case let .border(opacity):
            return Color(.border(opacity))
        }
    }
}

// MARK: - Palette (Hashable)

extension Palette: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(suColor)
    }
}
