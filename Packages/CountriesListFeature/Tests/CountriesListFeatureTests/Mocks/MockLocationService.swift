//
//  MockLocationService.swift
//  CountriesListFeatureTests
//

import Foundation
import Location

final class MockLocationService: LocationServiceProtocol, @unchecked Sendable {
    
    var countryCode: String = "EG"
    var error: Error?
    
    var getCurrentCountryCodeCallCount = 0
    
    func getCurrentCountryCode() async throws -> String {
        getCurrentCountryCodeCallCount += 1
        
        if let error = error {
            throw error
        }
        
        return countryCode
    }
    
    func reset() {
        countryCode = "EG"
        error = nil
        getCurrentCountryCodeCallCount = 0
    }
}

