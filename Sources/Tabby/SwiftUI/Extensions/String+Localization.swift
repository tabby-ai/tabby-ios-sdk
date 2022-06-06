//
//  String+Localization.swift
//  
//
//  Created by ilya.kuznetsov on 04.02.2022.
//

import SwiftUI

// MARK: - String ()

public extension String {
    var localized: String { NSLocalizedString(self, bundle: .main, comment: "") }
    //var localized: String { NSLocalizedString(self, bundle: .module, comment: "") }
}
