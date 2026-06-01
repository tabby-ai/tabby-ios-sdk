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
    /// - Parameter baseUrl: Region-resolved Checkout API host (e.g. `https://api.tabby.ai`).
    ///   The `/api/v2/checkout` path is appended here so callers only deal with the host.
    /// - Note: It is highly recommended to send a non-empty order history if a customer had some orders.
    func createSession(
        payload: TabbyCheckoutPayload,
        apiKey: String,
        baseUrl: String,
        completed: @escaping (Result<CheckoutSession, CheckoutError>) -> Void
    ) {
        networkService.performRequest(
            url: "\(baseUrl)/api/v2/checkout",
            method: "POST",
            headers: [
                "Content-Type": "application/json",
                "Accept": "application/json",
                SdkVersionHeader.key: SdkVersionHeader.value,
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
