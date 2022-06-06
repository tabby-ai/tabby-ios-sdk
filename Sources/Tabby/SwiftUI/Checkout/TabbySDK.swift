//
//  TabbySDK.swift
//  
//
//  Created by Dmitrii Ziablikov on 01.06.2022.
//

import Combine
import Foundation

// MARK: - TabbySDK

public final class TabbySDK {
    public typealias SessionCompletion = Result<(sessionId: String, paymentId: String, tabbyProductTypes: [TabbyProductType]), APIError>
    
    public static let shared = TabbySDK()
    
    public var session: CheckoutSession?

    private let apiClient = APIClient()
    private var apiKey = ""
    
    public func setup(withApiKey apiKey: String) {
        self.apiKey = apiKey
    }
    
    public func getApiKey() -> String { apiKey }
    
    public func configure(forPayment payload: TabbyCheckoutPayload, completion: @escaping (SessionCompletion) -> ()) {
        apiClient.checkout(payload: payload) { [weak self] res in
            DispatchQueue.main.async {
                switch res {
                case let .success(session):
                    guard let self = self else { return completion(.failure(.internalError)) }
                    self.session = session
                    let result = self.createResult(session: session)
                    completion(.success(result))
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func configure(forPayment payload: TabbyCheckoutPayload) async throws -> (SessionCompletion) {
        let res = try await apiClient.checkoutAsync(payload: payload)
        switch res {
        case let .success(session):
            self.session = session
            let result = self.createResult(session: session)
            return .success(result)
        case .failure(let error):
            print(error.localizedDescription)
            return .failure(error)
        }
    }
    
    private func createResult(session: CheckoutSession) -> (sessionId: String, paymentId: String, tabbyProductTypes: [TabbyProductType]) {
        let tabbyProductTypes: [TabbyProductType] = TabbyProductType.allCases.filter {
            session.configuration.availableProducts[$0.rawValue] != nil
        }
        let result: (sessionId: String, paymentId: String, tabbyProductTypes: [TabbyProductType]) = (
            sessionId: session.id,
            paymentId: session.payment.id,
            tabbyProductTypes: tabbyProductTypes
        )
        return result
    }
}
