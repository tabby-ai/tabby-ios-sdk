//
//  View+Builder.swift
//  
//
//  Created by ilya.kuznetsov on 28.09.2021.
//

import SwiftUI
import Combine

// MARK: - View ()

extension View {
    @ViewBuilder func valueChanged<T: Equatable>(value: T, onChange: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, *) {
            self.onChange(of: value, perform: onChange)
        } else {
            self.onReceive(Just(value)) { value in
                onChange(value)
            }
        }
    }
}
