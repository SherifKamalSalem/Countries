//
//  CountriesEndpoint.swift
//  Networking
//
//  Created by Sherif Kamal on 02/12/2025.
//


import Foundation

public enum CountriesEndpoint: Endpoint, Sendable {
    case getAllCountries
    case searchByName(String)
    
    public var path: String {
        switch self {
        case .getAllCountries:
            return "/v2/all"
        case .searchByName(let name):
            let encoded = name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? name
            return "/v2/name/\(encoded)"
        }
    }
    
    public var method: HTTPMethod {
        .get
    }
    
    public var queryParameters: [String: String] {
        switch self {
        case .getAllCountries:
            // Only fetch fields we need for the list
            return ["fields": "name,capital,currencies,flags"]
        case .searchByName:
            return [:]
        }
    }
}

