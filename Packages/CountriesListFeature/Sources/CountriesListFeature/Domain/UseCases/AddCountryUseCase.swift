//
//  AddCountryUseCase.swift
//  CountriesListFeature
//
//  Created by Sherif Kamal on 02/12/2025.
//


import Foundation
import Core
import Storage

/// Use case for adding a country to saved list
/// Encapsulates business rules: max 5 countries, no duplicates
public struct AddCountryUseCase: Sendable {
    
    public enum Result: Sendable {
        case added
        case alreadyExists
        case limitReached
    }
    
    private let storageService: StorageServiceProtocol
    private let maxCountries = 5
    
    public init(storageService: StorageServiceProtocol) {
        self.storageService = storageService
    }
    
    public func execute(country: Country) async -> Result {
        let currentCountries = await storageService.loadCountries()
        
        if currentCountries.contains(where: { $0.id == country.id }) {
            return .alreadyExists
        }
        
        guard currentCountries.count < maxCountries else {
            return .limitReached
        }
        
        _ = await storageService.addCountry(country)
        return .added
    }
}

