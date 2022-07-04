//
//  File.swift
//  
//
//  Created by ilya.kuznetsov on 23.04.2022.
//

import SwiftUI

struct AmountTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 11, weight: .bold))
            .padding(.top, 6)
            .multilineTextAlignment(.center)
            .foregroundColor(textPrimaryColor)
    }
}

struct WhenTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 11, weight: .bold))
            .padding(.top, 4)
            .multilineTextAlignment(.center)
            .foregroundColor(textSecondaryColor)
    }
}
