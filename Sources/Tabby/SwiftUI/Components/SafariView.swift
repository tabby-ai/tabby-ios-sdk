//
//  SafariView.swift
//
//
//  Created by ilya.kuznetsov on 30.08.2021.
//

import SwiftUI
import SafariServices

// MARK: - SafariView

struct SafariView: UIViewControllerRepresentable {
    
    // MARK: - Private Properties

    private let url: URL
    
    // MARK: - Life Cycle

    init(lang: Lang, customUrl: String? = nil) {
        let link = customUrl ?? CheckoutLink.link(for: .installments(lang))
        self.url = URL(string: link)!
    }
    
    // MARK: - Internal Methods

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController { .init(url: url) }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context:  UIViewControllerRepresentableContext<SafariView>) {}
}
