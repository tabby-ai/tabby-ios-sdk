//
//  WebKitView.swift
//  Tabby
//
//  Created by ilya.kuznetsov on 26.08.2021.
//

import SwiftUI
import WebKit
import UIKit

@available(iOS 14.0, *)
struct CheckoutWebView: UIViewRepresentable {
  var productType: TabbyProductType
  var url: String?
  var vc: TabbyCheckoutViewModel

  func makeCoordinator() -> Coordinator {
    Coordinator()
  }

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
    // updateUIView fires on every @Published change of the view model, not just when
    // `url` is set — reload only on an actual URL change, otherwise the checkout
    // session's /initialize is requested twice (MPC-2731).
    if let urlValue = url, urlValue != context.coordinator.loadedURL {
      if let requestUrl = URL(string: urlValue) {
        context.coordinator.loadedURL = urlValue
        webView.load(URLRequest(url: requestUrl))
      }
    }
  }

  class Coordinator {
    /// Last URL handed to `webView.load`; `webView.url` can't be used for this check
    /// because in-page redirects change it away from the originally requested URL.
    var loadedURL: String?
  }
}
