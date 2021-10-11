//
//  NetworkManager.swift
//  Tabby
//
//  Created by ilya.kuznetsov on 26.08.2021.
//

import Foundation

final class Api {
    static let shared = Api()
    
    static let tabbyApiHost = "https://api.tabby.ai/api/v2"
    static let tabbyCheckoutHost = "https://checkout.tabby.ai/"
    
    private let createSessionUrl = tabbyApiHost + "/checkout"
    
    private init() {}
    
    func createSession(payload: TabbyCheckoutPayload, apiKey: String, completed: @escaping (Result<CheckoutSession, CheckoutError>) -> Void) {
        var jsonBody: String = ""
        do {
            let jsonData = try JSONEncoder().encode(payload)
            jsonBody = String(data: jsonData, encoding: .utf8)!
        } catch {
            completed(.failure(.invalidData))
            return
        }
        
        print(jsonBody)
        
        guard let url = URL(string: createSessionUrl) else {
            completed(.failure(.invalidUrl))
            return
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        print(createSessionUrl)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(CheckoutSession.self, from: data)
                completed(.success(decodedResponse))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
}
