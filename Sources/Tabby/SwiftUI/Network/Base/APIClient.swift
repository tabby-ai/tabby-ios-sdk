//
//  APIClient.swift
//  Tabby
//
//  Created by ilya.kuznetsov on 26.08.2021.
//

import Combine
import Foundation

// MARK: - CheckoutProvider

protocol CheckoutProvider {
    func checkout(payload: TabbyCheckoutPayload, apiKey: String, completion: @escaping((Result<CheckoutSession, APIError>) -> Void))
    func checkoutPublisher(payload: TabbyCheckoutPayload, apiKey: String) -> AnyPublisher<CheckoutSession, APIError>
    func checkoutAsync(payload: TabbyCheckoutPayload, apiKey: String) async throws -> (Result<CheckoutSession, APIError>)
}

// MARK: - APIClient

final class APIClient {
    
    // MARK: - Private Properties

    private let baseURL = "https://api.tabby.ai"
    private let version = "/api/v2"
    
    // MARK: - Endpoint

    private enum Endpoint: String {
        case checkout = "/checkout"
    }
    
    // MARK: - Method

    private enum Method: String {
        case get
        case post
    }
    
    // MARK: - Private Methods

    private func request(for endpoint: Endpoint, method: Method, apiKey: String) -> URLRequest {
        let path = "\(baseURL)\(version)\(endpoint.rawValue)"
        guard let url = URL(string: path) else { preconditionFailure("Bad URL") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "\(method)".uppercased()
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    /// Callback Request
    private func send<T: Codable>(with endPoint: Endpoint, method: Method, apiKey: String, completion: @escaping((Result<T, APIError>) -> Void)) {
        let urlRequest = request(for: endPoint, method: method, apiKey: apiKey)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard error == nil else { completion(.failure(.serverError)); return }
            
            do {
                guard let data = data else { completion(.failure(.invalidData)); return }
                let object = try JSONDecoder().decode(T.self, from: data)
                completion(.success(object))
            } catch {
                completion(.failure(.parsingError))
            }
        }
        dataTask.resume()
    }
    
    /// Combine Request
    private func send<T: Codable>(with endPoint: Endpoint, method: Method, apiKey: String) -> AnyPublisher<T, APIError> {
        let urlRequest = request(for: endPoint, method: method, apiKey: apiKey)
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError { _ in APIError.serverError }
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { _ in APIError.parsingError }
            .eraseToAnyPublisher()
    }
    
    /// Async/await Request
    private func send(with endPoint: Endpoint, method: Method, apiKey: String) async throws -> (Data, URLResponse) {
        let urlRequest = request(for: endPoint, method: method, apiKey: apiKey)
        
        if #available(iOS 15.0, *) {
            return try await URLSession.shared.data(for: urlRequest)
        } else {
            return try await withCheckedThrowingContinuation { continuation in
                let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                    guard let data = data, let response = response else {
                        let error = error ?? URLError(.badServerResponse)
                        return continuation.resume(throwing: error)
                    }
                    continuation.resume(returning: (data, response))
                }
                task.resume()
            }
        }
    }
}

// MARK: - APIClient (CheckoutProvider)

extension APIClient: CheckoutProvider {
    func checkout(payload: TabbyCheckoutPayload, apiKey: String, completion: @escaping((Result<CheckoutSession, APIError>) -> Void)) {
        send(with: .checkout, method: .post, apiKey: apiKey, completion: completion)
    }
    
    func checkoutPublisher(payload: TabbyCheckoutPayload, apiKey: String) -> AnyPublisher<CheckoutSession, APIError> {
        send(with: .checkout, method: .post, apiKey: apiKey)
    }
    
    func checkoutAsync(payload: TabbyCheckoutPayload, apiKey: String) async throws -> (Result<CheckoutSession, APIError>) {
        do {
            let (data, _) = try await send(with: .checkout, method: .post, apiKey: apiKey)
            let object = try JSONDecoder().decode(CheckoutSession.self, from: data)
            return .success(object)
        } catch {
            return .failure(.parsingError)
        }
    }
}
