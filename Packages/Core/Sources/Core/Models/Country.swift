//
//  Country.swift
//  Core
//
//  Created by Sherif Kamal on 01/12/2025.
//

import Foundation

public struct Country: Identifiable, Hashable, Codable, Sendable {
    public let id: String
    public let name: String
    public let capital: String?
    public let flagURL: URL?
    public let currencies: [Currency]
    
    public init(
        id: String,
        name: String,
        capital: String?,
        flagURL: URL?,
        currencies: [Currency]
    ) {
        self.id = id
        self.name = name
        self.capital = capital
        self.flagURL = flagURL
        self.currencies = currencies
    }
    
    public struct Currency: Hashable, Codable, Sendable {
        public let code: String
        public let name: String
        public let symbol: String
        
        public init(code: String, name: String, symbol: String) {
            self.code = code
            self.name = name
            self.symbol = symbol
        }
    }
}

// MARK: - Mock for testing/previews
public extension Country {
    static func mock(
        id: String = "EG",
        name: String = "Egypt",
        capital: String? = "Cairo",
        flagURL: URL? = URL(string: "https://flagcdn.com/w320/eg.png"),
        currencies: [Currency] = [Currency(code: "EGP", name: "Egyptian pound", symbol: "£")]
    ) -> Country {
        Country(
            id: id,
            name: name,
            capital: capital,
            flagURL: flagURL,
            currencies: currencies
        )
    }
}

