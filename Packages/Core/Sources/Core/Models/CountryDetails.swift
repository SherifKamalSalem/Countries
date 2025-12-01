//
//  CountryDetails.swift
//  Core
//
//  Created by Sherif Kamal on 01/12/2025.
//

import Foundation

public struct CountryDetail: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let nativeName: String?
    public let capital: String?
    public let region: String?
    public let subregion: String?
    public let population: Int?
    public let area: Double?
    public let flagURL: URL?
    public let currencies: [Currency]
    public let languages: [Language]
    public let borders: [String]
    public let timezones: [String]
    
    public init(
        id: String,
        name: String,
        nativeName: String?,
        capital: String?,
        region: String?,
        subregion: String?,
        population: Int?,
        area: Double?,
        flagURL: URL?,
        currencies: [Currency],
        languages: [Language],
        borders: [String],
        timezones: [String]
    ) {
        self.id = id
        self.name = name
        self.nativeName = nativeName
        self.capital = capital
        self.region = region
        self.subregion = subregion
        self.population = population
        self.area = area
        self.flagURL = flagURL
        self.currencies = currencies
        self.languages = languages
        self.borders = borders
        self.timezones = timezones
    }
    
    public struct Currency: Sendable {
        public let code: String
        public let name: String
        public let symbol: String
        
        public init(code: String, name: String, symbol: String) {
            self.code = code
            self.name = name
            self.symbol = symbol
        }
    }
    
    public struct Language: Sendable {
        public let name: String
        public let nativeName: String?
        
        public init(name: String, nativeName: String?) {
            self.name = name
            self.nativeName = nativeName
        }
    }
}

// MARK: - Mock
public extension CountryDetail {
    static func mock() -> CountryDetail {
        CountryDetail(
            id: "EG",
            name: "Egypt",
            nativeName: "مصر",
            capital: "Cairo",
            region: "Africa",
            subregion: "Northern Africa",
            population: 102_334_404,
            area: 1_002_450,
            flagURL: URL(string: "https://flagcdn.com/w320/eg.png"),
            currencies: [Currency(code: "EGP", name: "Egyptian pound", symbol: "£")],
            languages: [Language(name: "Arabic", nativeName: "العربية")],
            borders: ["ISR", "LBY", "PSE", "SDN"],
            timezones: ["UTC+02:00"]
        )
    }
}
