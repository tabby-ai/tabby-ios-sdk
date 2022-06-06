//
//  TabbyCheckoutViewModel.swift
//  Tabby
//
//  Created by ilya.kuznetsov on 27.08.2021.
//

import SwiftUI
import WebKit
import UIKit
import Foundation
import Combine

// MARK: - TabbyResult

public struct TabbyResult {
    
    // MARK: - Internal Properties

    let productType: TabbyProductType
    var link = ""
}

// MARK: - TabbyCheckoutViewModel

final class TabbyCheckoutViewModel: NSObject, ObservableObject {
    
    @Published private(set) var result: TabbyState?
    @Published private(set) var state: CheckoutFlow.ViewState = .idle
    
    private let eventSubject = PassthroughSubject<CheckoutFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<CheckoutFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    
    private let productType: TabbyProductType
        
    // MARK: - Life Cycle

    public init(productType: TabbyProductType) {
        self.productType = productType
        super.init()
        bindInput()
        bindOutput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    // MARK: - Internal Methods

    func send(_ event: CheckoutFlow.Event) {
        eventSubject.send(event)
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.checkProducts()
                }
            }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }
    
    private func checkProducts() {
        stateValueSubject.send(.loading)
        
        guard
            let session = TabbySDK.shared.session,
            let product = session.configuration.availableProducts[productType.rawValue]?.first
        else {
            stateValueSubject.send(.error(APIError.internalError.localizedDescription))
            return
        }
        
        stateValueSubject.send(.result(.init(productType: productType, link: product.webUrl)))
    }
}

// MARK: - TabbyCheckoutViewModel (WKScriptMessageHandler)

extension TabbyCheckoutViewModel: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let message = message.body as? String else {
            self.result = .close
            return
        }
        
        let parsedMessage = message.trimmingCharacters(in: CharacterSet(charactersIn: "\""))

        DispatchQueue.main.async {
            self.result = TabbyState(rawValue: parsedMessage) ?? .close
        }
    }
}
