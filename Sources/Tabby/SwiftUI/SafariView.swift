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
    let url: URL

    /// Callers build the full URL from the geo-resolved `webCheckoutBaseUrl`, so a malformed
    /// string here would be a programmer error in the SDK itself.
    init(urlString: String) {
        self.url = URL(string: urlString)!
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {}
}
