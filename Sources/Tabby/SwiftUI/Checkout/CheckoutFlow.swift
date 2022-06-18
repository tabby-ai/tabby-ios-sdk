//
//  CheckoutFlow.swift
//  
//
//  Created by Dmitrii Ziablikov on 03.06.2022.
//

import Foundation

// MARK: - CheckoutFlow

enum CheckoutFlow {

    // MARK: - ViewState

    enum ViewState {

        // MARK: - Types

        case idle
        case loading
        case result(TabbyResult)
        case error(String)
    }

    // MARK: - Event

    enum Event {

        // MARK: - Types

        case onAppear
    }
}
