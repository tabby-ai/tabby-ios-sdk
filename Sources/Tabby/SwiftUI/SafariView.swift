//
//  SwiftUIView.swift
//
//
//  Created by ilya.kuznetsov on 30.08.2021.
//

import SwiftUI
import SafariServices

@available(iOS 13.0, *)
struct SafariView: UIViewControllerRepresentable {
    let lang: Lang
    let link: String
    let url: URL?
    
    init(lang: Lang) {
        self.lang = lang
        self.link = lang == Lang.en ? webViewUrls[.en]! : webViewUrls[.ar]!
        self.url = URL(string: self.link)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        let vc = SFSafariViewController(url: url!)
        return vc
        
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context:  UIViewControllerRepresentableContext<SafariView>) {}
}

