//
//  File.swift
//  
//
//  Created by ilya.kuznetsov on 04.02.2022.
//

import Foundation

extension Double {
    var withFormattedAmount: String {
      return String(format: "%.2f", self)
    }
}

