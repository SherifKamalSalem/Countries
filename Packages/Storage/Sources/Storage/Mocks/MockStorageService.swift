//
//  MockStorageService.swift
//  Storage
//
//  Created by Sherif Kamal on 02/12/2025.
//


import Foundation
import Core

public final class MockStorageService: StorageServiceProtocol, @unchecked Sendable {
    
    public var storedCountries: [Country] = []
    public var addShouldFail = false
    
    public init() {}
    
    public func saveCountries(_ countries: [Country]) async {
        storedCountries = Array(countries.prefix(5))
    }
    
    public func loadCountries() async -> [Country] {
        storedCountries
    }
    
    public func addCountry(_ country: Country) async -> Bool {
        if addShouldFail { return false }
        if storedCountries.count >= 5 { return false }
        if storedCountries.contains(where: { $0.id == country.id }) { return true }
        storedCountries.append(country)
        return true
    }
    
    public func removeCountry(id: String) async {
        storedCountries.removeAll { $0.id == id }
    }
    
    public func clearAll() async {
        storedCountries = []
    }
}

