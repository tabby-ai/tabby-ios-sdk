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
    Images.round1:  "https://cdn.tabby.ai/assets/Round1.png",
    Images.round2: "https://cdn.tabby.ai/assets/Round2.png",
    Images.round3: "https://cdn.tabby.ai/assets/Round3.png",
    Images.round4: "https://cdn.tabby.ai/assets/Round4.png"
]
