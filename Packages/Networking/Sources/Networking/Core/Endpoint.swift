//
//  Endpoint.swift
//  Networking
//
//  Created by Sherif Kamal on 02/12/2025.
//


import Foundation

public protocol Endpoint: Sendable {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
    var body: [String: Any]? { get }
}

// Default implementations
public extension Endpoint {
    var baseURL: String {
        "https://restcountries.com"
    }
    
    var headers: [String: String] {
        ["Accept": "application/json"]
    }
    
    var queryParameters: [String: String] {
        [:]
    }
    
    var body: [String: Any]? {
        nil
    }
}

