//
//  ActivityIndicator.swift
//  
//
//  Created by ilya.kuznetsov on 23.04.2022.
//

import SwiftUI

@available(iOS 14.0, *)
struct ActivityIndicator: UIViewRepresentable {
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        uiView.startAnimating()
    }
}

@available(iOS 14.0, *)
struct ActivityIndicator_Preview: PreviewProvider {
  static var previews: some View {
    ActivityIndicator(style: .large)
        .previewLayout(.sizeThatFits)
  }
}
