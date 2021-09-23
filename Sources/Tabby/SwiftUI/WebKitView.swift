//
//  WebKitView.swift
//  TabbyDemo
//
//  Created by ilya.kuznetsov on 12.09.2021.
//

import SwiftUI
import WebKit
import UIKit


enum URLType {
    case local, `public`
}

enum Signal: String {
    case closed = "closed"
    case authorized = "authorized"
    case rejected = "rejected"
}

@available(iOS 13.0, *)
struct WebView: UIViewRepresentable  {
    
    var url: String?
    
    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKPreferences()
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        
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
