//
//  NetworkService.swift
//  Networking
//
//  Created by Sherif Kamal on 02/12/2025.
//


import Foundation

public protocol NetworkServiceProtocol: Sendable {
    func request<T: Decodable & Sendable>(_ endpoint: Endpoint) async throws -> T
}

public final class NetworkService: NetworkServiceProtocol, @unchecked Sendable {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    public init(
        session: URLSession = .shared,
        decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            return decoder
        }()
    ) {
        self.session = session
        self.decoder = decoder
    }
    
    public func request<T: Decodable & Sendable>(_ endpoint: Endpoint) async throws -> T {
        let request = try buildRequest(from: endpoint)
        
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch let urlError as URLError {
            if urlError.code == .notConnectedToInternet || urlError.code == .networkConnectionLost {
                throw NetworkError.offline
            }
            throw NetworkError.unknown(urlError.localizedDescription)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            break // Success
        case 404:
            throw NetworkError.notFound
        case 400...499:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        case 500...599:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        default:
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoded = try decoder.decode(T.self, from: data)
            return decoded
        } catch let decodingError {
            #if DEBUG
            debugPrint("Decoding error: \(decodingError)")
            if let jsonString = String(data: data, encoding: .utf8) {
                debugPrint("Response: \(jsonString.prefix(500))")
            }
            #endif
            throw NetworkError.decodingFailed(decodingError.localizedDescription)
        }
    }
    
    private func buildRequest(from endpoint: Endpoint) throws -> URLRequest {
        var components = URLComponents(string: endpoint.baseURL + endpoint.path)
        
        if !endpoint.queryParameters.isEmpty {
            components?.queryItems = endpoint.queryParameters.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        request.timeoutInterval = 30
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
}

