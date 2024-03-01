import Foundation

public enum NetworkError: Error {
    
    case invalidUrl
    case requestEncodingFailed
    case responseDecodingFailed
    case invalidResponse
    case noResponse
}

final class NetworkService {
    
    static let shared = NetworkService()
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    private init() {}
    
    func performRequest<RequestBody: Encodable, ResponseBody: Decodable>(
        url: String,
        method: String,
        headers: [String: String],
        body: RequestBody?,
        completed: @escaping (Result<ResponseBody, Error>) -> Void
    ) {
        guard let url = URL(string: url) else {
            completed(.failure(NetworkError.invalidUrl))
            return
        }
        
        performRequest(url: url, method: method, headers: headers, body: body, completed: completed)
    }
    
    func performRequest<RequestBody: Encodable, ResponseBody: Decodable>(
        url: URL,
        method: String,
        headers: [String: String],
        body: RequestBody?,
        completed: @escaping (Result<ResponseBody, Error>) -> Void
    ) {
        performRequest(url: url, method: method, headers: headers, body: body) {
            switch $0 {
            case .failure(let error):
                completed(.failure(error))
            
            case .success(let data):
                guard let data = data else {
                    completed(.failure(NetworkError.noResponse))
                    return
                }
                
                do {
                    let decodedResponse = try self.decoder.decode(ResponseBody.self, from: data)
                    completed(.success(decodedResponse))
                } catch {
                    completed(.failure(NetworkError.responseDecodingFailed))
                }
            }
        }
    }
    
    func performRequest<RequestBody: Encodable>(
        url: URL,
        method: String,
        headers: [String: String],
        body: RequestBody?,
        completed: @escaping (Result<Data?, Error>) -> Void
    ) {
        var request = URLRequest(url: url)
        
        request.httpMethod = method
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        do {
            request.httpBody = try self.encoder.encode(body)
        } catch {
            completed(.failure(NetworkError.requestEncodingFailed))
            return
        }
                
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                completed(.failure(error))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(NetworkError.invalidResponse))
                return
            }
            
            completed(.success(data))
        }.resume()
    }
    
    /// Prepares curl description for the request
    private func prepareDescription(_ request: URLRequest) -> String {
        var description = "curl -X \(request.httpMethod ?? "GET")"
        
        if let headers = request.allHTTPHeaderFields {
            for (key, value) in headers {
                description += " -H '\(key): \(value)'"
            }
        }
        
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            description += " -d '\(bodyString)'"
        }
        
        description += " \(request.url?.absoluteString ?? "")"
        
        return description
    }
    
    private func prepareResponseDescription(_ response: URLResponse?, data: Data?) -> String {
        var description = ""
        
        if let response = response as? HTTPURLResponse {
            description += "Status code: \(response.statusCode)\n"
        }
        
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            description += "Response: \(dataString)"
        }
        
        return description
    }
}
