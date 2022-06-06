//
//  Double+Format.swift
//  
//
//  Created by ilya.kuznetsov on 04.02.2022.
//

import Foundation

// MARK: - Double ()

extension Double {
    var withFormattedAmount: String { String(format: "%.2f", self) }
}
