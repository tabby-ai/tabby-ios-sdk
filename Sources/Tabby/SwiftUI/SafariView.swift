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
    let customUrl: String?
    
    init(lang: Lang, customUrl: String? = nil) {
        self.lang = lang
        self.link = lang == Lang.en ? WebViewBaseURL.Tabby.en : WebViewBaseURL.Tabby.ar
        let finalUrl = customUrl ?? (lang == Lang.en ? WebViewBaseURL.Tabby.en : WebViewBaseURL.Tabby.ar)
        self.url = URL(string: finalUrl)
        self.customUrl = customUrl
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        let vc = SFSafariViewController(url: url!)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context:  UIViewControllerRepresentableContext<SafariView>) {}
}

