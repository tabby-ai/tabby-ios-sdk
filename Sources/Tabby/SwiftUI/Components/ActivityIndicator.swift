//
//  ActivityIndicator.swift
//  
//
//  Created by ilya.kuznetsov on 23.04.2022.
//

import SwiftUI

// MARK: - ActivityIndicator

struct ActivityIndicator: UIViewRepresentable {
    
    // MARK: - Internal Properties

    let style: UIActivityIndicatorView.Style
    
    // MARK: - Internal Methods

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView { .init(style: style) }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) { uiView.startAnimating() }
}

struct ActivityIndicator_Preview: PreviewProvider {
    static var previews: some View {
        ActivityIndicator(style: .large)
            .previewLayout(.sizeThatFits)
    }
}
