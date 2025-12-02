//
//  NetworkError.swift
//  Networking
//
//  Created by Sherif Kamal on 02/12/2025.
//


import Foundation

public enum NetworkError: Error, LocalizedError, Sendable {
    case invalidURL
    case noData
    case decodingFailed(String)
    case serverError(statusCode: Int)
    case invalidResponse
    case offline
    case notFound
    case unknown(String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received from server"
        case .decodingFailed(let message):
            return "Failed to decode response: \(message)"
        case .serverError(let code):
            return "Server error (\(code))"
        case .invalidResponse:
            return "Invalid response from server"
        case .offline:
            return "No internet connection"
        case .notFound:
            return "Resource not found"
        case .unknown(let message):
            return message
        }
    }
    
    public var userMessage: String {
        switch self {
        case .offline:
            return "Please check your internet connection and try again."
        case .notFound:
            return "No results found. Try a different search."
        case .serverError:
            return "We're having trouble connecting. Please try again later."
        default:
            return "Something went wrong. Please try again."
        }
    }
}
