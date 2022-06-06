//
//  ViewStyle.swift
//  
//
//  Created by Dmitrii Ziablikov on 04.06.2022.
//

import Foundation
import SwiftUI

// MARK: - View ()

public extension View {
    func background(_ palette: Palette) -> some View {
        background(palette.suColor)
    }

    func foreground(_ palette: Palette) -> some View {
        foregroundColor(palette.suColor)
    }
}
