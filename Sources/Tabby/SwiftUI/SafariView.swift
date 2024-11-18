//
//  SwiftUIView.swift
//
//
//  Created by ilya.kuznetsov on 30.08.2021.
//

import SwiftUI
import SafariServices

@available(iOS 14.0, *)
struct SafariView: UIViewControllerRepresentable {
    let lang: Lang
    let link: String
    let url: URL?
    let customUrl: String?
    
    init(lang: Lang, customUrl: String? = nil) {
        self.lang = lang
        switch lang {
        case .en:
            self.link = BaseURL.WebView.Tabby.en
            self.url = URL(string: customUrl ?? BaseURL.WebView.Tabby.en)
        case .ar:
            self.link = BaseURL.WebView.Tabby.ar
            self.url =  URL(string: customUrl ?? BaseURL.WebView.Tabby.ar)
        }
        self.customUrl = customUrl
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        let vc = SFSafariViewController(url: url!)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context:  UIViewControllerRepresentableContext<SafariView>) {}
}

