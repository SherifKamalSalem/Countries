//
//  CountryDetailDTO.swift
//  Networking
//
//  Created by Sherif Kamal on 02/12/2025.
//


import Foundation

public struct CountryDetailDTO: Decodable, Sendable {
    public let name: String
    public let topLevelDomain: [String]?
    public let alpha2Code: String
    public let alpha3Code: String
    public let callingCodes: [String]?
    public let capital: String?
    public let altSpellings: [String]?
    public let subregion: String?
    public let region: String?
    public let population: Int?
    public let latlng: [Double]?
    public let demonym: String?
    public let area: Double?
    public let gini: Double?
    public let timezones: [String]?
    public let borders: [String]?
    public let nativeName: String?
    public let numericCode: String?
    public let flags: FlagsDTO
    public let currencies: [CurrencyDTO]?
    public let languages: [LanguageDTO]?
    public let translations: [String: String]?
    public let flag: String?
    public let regionalBlocs: [RegionalBlocDTO]?
    public let cioc: String?
    public let independent: Bool?
    
    public struct FlagsDTO: Decodable, Sendable {
        public let svg: String
        public let png: String
    }
    
    public struct CurrencyDTO: Decodable, Sendable {
        public let code: String?
        public let name: String?
        public let symbol: String?
    }
    
    public struct LanguageDTO: Decodable, Sendable {
        public let iso639_1: String?
        public let iso639_2: String?
        public let name: String?
        public let nativeName: String?
    }
    
    public struct RegionalBlocDTO: Decodable, Sendable {
        public let acronym: String?
        public let name: String?
        public let otherNames: [String]?
    }
}

