//
//  CountryDetailViewModel.swift
//  CountryDetailsFeature
//

import Foundation
import Core

@Observable
@MainActor
public final class CountryDetailViewModel {
    
    public private(set) var country: Country
    
    public init(country: Country) {
        self.country = country
    }
    
    public var formattedCapital: String {
        country.capital ?? "No capital information"
    }
    
    public var formattedCurrencies: String {
        guard !country.currencies.isEmpty else {
            return "No currency information"
        }
        
        return country.currencies.map { currency in
            if currency.symbol.isEmpty || currency.symbol.trimmingCharacters(in: .whitespaces).isEmpty {
                return "\(currency.name) (\(currency.code))"
            } else {
                return "\(currency.name) (\(currency.symbol))"
            }
        }.joined(separator: ", ")
    }
}
