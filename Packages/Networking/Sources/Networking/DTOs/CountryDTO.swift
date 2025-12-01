//
//  CountryDTO.swift
//  Networking
//
//  Created by Sherif Kamal on 02/12/2025.
//


import Foundation

public struct CountryDTO: Decodable, Sendable {
    public let name: String
    public let capital: String?
    public let flags: FlagsDTO
    public let currencies: [CurrencyDTO]?
    
    public struct FlagsDTO: Decodable, Sendable {
        public let svg: String
        public let png: String
    }
    
    public struct CurrencyDTO: Decodable, Sendable {
        public let code: String?
        public let name: String?
        public let symbol: String?
    }
}

