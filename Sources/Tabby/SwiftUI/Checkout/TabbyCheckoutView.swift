//
//  TabbyCheckoutView.swift
//  Tabby
//
//  Created by ilya.kuznetsov on 26.08.2021.
//

import SwiftUI

public struct TabbyCheckoutView: View {
    
    @ObservedObject private var viewModel: TabbyCheckoutViewModel
    
    public let onResult: (TabbyState) -> ()
    
    public init(productType: TabbyProductType, onResult: @escaping (TabbyState) -> ()) {
        self._viewModel = ObservedObject(wrappedValue: TabbyCheckoutViewModel(productType: productType))
        self.onResult = onResult
    }
    
    public var body: some View {
        ZStack {
            switch viewModel.state {
            case .idle, .loading:
                ActivityIndicator(style: .medium)
            case let .result(result):
                CheckoutWebView(link: result.link, delegate: viewModel)
            case let .error(message):
                Text(message)
            }
        }
        .valueChanged(value: viewModel.result) { value in
            guard let value = value else { return }
            onResult(value)
        }
        .onAppear {
            viewModel.send(.onAppear)
        }
    }
}
