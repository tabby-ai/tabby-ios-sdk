//
//  Images.swift
//  TabbyDemo
//
//  Created by ilya.kuznetsov on 12.09.2021.
//

import Foundation

public enum Images {
    case logo
    case circle1
    case circle2
    case circle3
    case circle4
}

let imgUrls: [Images:String] = [
    Images.logo: "https://cdn.tabby.ai/assets/logoimg.png",
    Images.circle1:  "https://cdn.tabby.ai/assets/R1-black.png",
    Images.circle2: "https://cdn.tabby.ai/assets/R2-black.png",
    Images.circle3: "https://cdn.tabby.ai/assets/R3-black.png",
    Images.circle4: "https://cdn.tabby.ai/assets/R4-black.png"
]
