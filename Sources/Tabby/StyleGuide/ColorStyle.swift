//
//  ColorStyle.swift
//  
//
//  Created by Dmitrii Ziablikov on 01.06.2022.
//

import SwiftUI

// MARK: - Color ()

public extension Color {

    // MARK: - Life Cycle

    init(_ palette: Palette) {
        self = palette.suColor
    }
}
