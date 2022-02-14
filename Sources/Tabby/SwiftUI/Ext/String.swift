//
//  File.swift
//  
//
//  Created by ilya.kuznetsov on 04.02.2022.
//

import SwiftUI

let TabbySdkBundle = Bundle.module

public extension String {
  var localized: String {
    NSLocalizedString(self, bundle: TabbySdkBundle, comment: "")
  }
}
