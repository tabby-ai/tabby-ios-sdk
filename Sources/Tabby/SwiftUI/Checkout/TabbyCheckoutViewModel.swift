//
//  TabbyCheckoutViewModel.swift
//  Tabby
//
//  Created by ilya.kuznetsov on 27.08.2021.
//

import SwiftUI
import WebKit
import UIKit

final class TabbyCheckoutViewModel: UIViewController, WKScriptMessageHandlerWithReply, ObservableObject, WKScriptMessageHandler, WKUIDelegate {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let msg = message.body as? String else {
            self.result = .close
            return
        }
        DispatchQueue.main.async {
            let parsedMessage = msg.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
            switch parsedMessage {
                case "close":
                    self.result = .close
                    break
                case "expired":
                    self.result = .expired
                    break
                case "authorized":
                    self.result = .authorized
                    break
                case "rejected":
                    self.result = .rejected
                    break
                default:
                    break
            }
        }
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage, replyHandler: @escaping (Any?, String?) -> Void) {
        // implementation is not required
    }
    
    @Published var session: CheckoutSession?
    @Published var pending: Bool = false
    @Published var installmentsButtonEnabled: Bool = false
    @Published var paylaterButtonEnabled: Bool = false
    @Published var installmentsURL: String?
    @Published var payLaterURL: String?
    @Published var result: TabbyResult?
    
}
