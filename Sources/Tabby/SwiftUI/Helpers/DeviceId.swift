//
//  File.swift
//  
//
//  Created by ilya.kuznetsov on 11.04.2022.
//

import Foundation
import UIKit

func getUniqueId() -> String {
    if let uuid = UIDevice.current.identifierForVendor?.uuidString {
        return uuid
    }
    return UUID().uuidString
}
