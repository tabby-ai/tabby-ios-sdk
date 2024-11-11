//
//  NetworkManager.swift
//  Tabby
//
//

import Foundation

final class Api {
    
    static let shared = Api(networkService: .shared)
    
    private let networkService: NetworkService
    
    private init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    /// Creates a checkout session.
    ///
    /// - Note: It is highly recommended to send a non-empty order history if a customer had some orders.
    func createSession(payload: TabbyCheckoutPayload, apiKey: String, completed: @escaping (Result<CheckoutSession, CheckoutError>) -> Void) {
        networkService.performRequest(
            url: BaseURL.checkout,
            method: "POST",
            headers: [
                "Content-Type": "application/json",
                "Accept": "application/json",
                "X-SDK-Version": "iOS/\(version)",
                "Authorization": "Bearer \(apiKey)"
            ],
            body: payload
        ) { (result: Result<CheckoutSession, Error>) in
            switch result {
            case .success(let session):
                completed(.success(session))
            case .failure(let error):
                if let error = error as? NetworkError {
                    switch error {
                    case .invalidUrl:
                        completed(.failure(.invalidUrl))
                    case .requestEncodingFailed:
                        completed(.failure(.unableToComplete))
                    case .responseDecodingFailed:
                        completed(.failure(.unableToDecode))
                    case .invalidResponse:
                        completed(.failure(.invalidResponse))
                    case .noResponse:
                        completed(.failure(.noResponse))
                    }
                }
                completed(.failure(.unableToComplete))
            }
        }
    }
}
