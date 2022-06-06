//
//  CheckoutWebView.swift
//  Tabby
//
//  Created by ilya.kuznetsov on 26.08.2021.
//

import SwiftUI
import WebKit
import UIKit

// MARK: - CheckoutWebView

struct CheckoutWebView: UIViewRepresentable {

    // MARK: - Internal Properties

    let link: String?
    let delegate: WKScriptMessageHandler
    
    // MARK: - Internal Methods

    func makeUIView(context: Context) -> WKWebView {        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = WKPreferences()
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = true
        
        let contentController = webView.configuration.userContentController
        contentController.add(delegate, name: "tabbyMobileSDK")
                
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let link = link, let url = URL(string: link) else { return }
        webView.load(URLRequest(url: url))
    }
}
