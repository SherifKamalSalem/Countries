//
//  MockCountriesRepository.swift
//  CountriesListFeature
//
//  Created by Sherif Kamal on 02/12/2025.
//


import Foundation
import Core
import Networking

public final class MockCountriesRepository: CountriesRepositoryProtocol, @unchecked Sendable {
    
    public var mockCountries: [Country] = [
        .mock(id: "EG", name: "Egypt", capital: "Cairo"),
        .mock(id: "US", name: "United States", capital: "Washington, D.C."),
        .mock(id: "SA", name: "Saudi Arabia", capital: "Riyadh"),
    ]
    
    public var shouldFail = false
    public var delay: TimeInterval = 0
    
    public init() {}
    
    public func fetchAllCountries() async throws -> [Country] {
        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        if shouldFail { throw NetworkError.offline }
        return mockCountries
    }
    
    public func searchCountries(by name: String) async throws -> [Country] {
        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        if shouldFail { throw NetworkError.offline }
        
        return mockCountries.filter {
            $0.name.lowercased().contains(name.lowercased())
        }
    }
    
    public func getCountryDetails(by code: String) async throws -> Country {
        if shouldFail { throw NetworkError.offline }
        return .mock(id: code, name: "Country \(code)", capital: "Capital \(code)")
    }
    
    public func getCountryDetails(name: String) async throws -> CountryDetail {
        if shouldFail { throw NetworkError.offline }
        return .mock()
    }
}

