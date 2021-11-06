//
//  Images.swift
//  TabbyDemo
//
//  Created by ilya.kuznetsov on 12.09.2021.
//

import Foundation

public enum Images {
    case logo
    case round1
    case round2
    case round3
    case round4
}

let imgUrls: [Images:String] = [
    Images.logo: "https://cdn.tabby.ai/assets/logoimg.png",
    Images.round1:  "https://cdn.tabby.ai/assets/R1-black.png",
    Images.round2: "https://cdn.tabby.ai/assets/R2-black.png",
    Images.round3: "https://cdn.tabby.ai/assets/R3-black.png",
    Images.round4: "https://cdn.tabby.ai/assets/R4-black.png"
]
