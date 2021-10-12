//
//  WebKitView.swift
//  Tabby
//
//  Created by ilya.kuznetsov on 26.08.2021.
//

import SwiftUI
import WebKit
import UIKit


enum URLType {
    case local, `public`
}

@available(iOS 13.0, *)
struct CheckoutWebView: UIViewRepresentable  {
    var type: URLType
    var productType: ProductType
    var url: String?
    var vc: TabbyCheckoutViewModel
    
    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKPreferences()
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        
        let contentController = webView.configuration.userContentController
        contentController.add(vc, name: "tabbyMobileSDK")
        
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = true
        
        return webView
        
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let urlValue = url  {
            if let requestUrl = URL(string: urlValue) {
                webView.load(URLRequest(url: requestUrl))
            }
        }
    }
}
