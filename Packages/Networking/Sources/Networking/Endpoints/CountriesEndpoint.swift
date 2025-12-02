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
    case searchByCode(String)
    
    public var path: String {
        switch self {
        case .getAllCountries:
            return "/v2/all"
        case .searchByName(let name):
            let encoded = name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? name
            return "/v2/name/\(encoded)"
        case .searchByCode(let code):
            return "/v2/alpha/\(code)"
            
        }
    }
    
    public var method: HTTPMethod {
        .get
    }
    
    public var queryParameters: [String: String] {
        switch self {
        case .getAllCountries:
            return ["fields": "name,capital,currencies,flags"]
        case .searchByName, .searchByCode:
            return [:]
        }
    }
}

