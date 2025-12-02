//
//  MockCountriesRepository.swift
//  CountriesListFeatureTests
//

import Foundation
import Core

final class MockCountriesRepository: CountriesRepositoryProtocol, @unchecked Sendable {
    
    var allCountries: [Country] = []
    var searchResults: [Country] = []
    var countryDetails: [String: Country] = [:]
    var countryDetailByName: [String: CountryDetail] = [:]
    
    var fetchAllError: Error?
    var searchError: Error?
    var getCountryDetailsError: Error?
    var getCountryDetailsByNameError: Error?
    
    var fetchAllCallCount = 0
    var searchCallCount = 0
    var getCountryDetailsCallCount = 0
    var getCountryDetailsByNameCallCount = 0
    
    func fetchAllCountries() async throws -> [Country] {
        fetchAllCallCount += 1
        if let error = fetchAllError {
            throw error
        }
        return allCountries
    }
    
    func searchCountries(by name: String) async throws -> [Country] {
        searchCallCount += 1
        if let error = searchError {
            throw error
        }
        return searchResults
    }
    
    func getCountryDetails(by code: String) async throws -> Country {
        getCountryDetailsCallCount += 1
        if let error = getCountryDetailsError {
            throw error
        }
        if let country = countryDetails[code] {
            return country
        }
        throw NSError(domain: "TestError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Country not found"])
    }
    
    func getCountryDetails(name: String) async throws -> CountryDetail {
        getCountryDetailsByNameCallCount += 1
        if let error = getCountryDetailsByNameError {
            throw error
        }
        if let detail = countryDetailByName[name] {
            return detail
        }
        throw NSError(domain: "TestError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Country not found"])
    }
    
    func reset() {
        allCountries = []
        searchResults = []
        countryDetails = [:]
        countryDetailByName = [:]
        fetchAllError = nil
        searchError = nil
        getCountryDetailsError = nil
        getCountryDetailsByNameError = nil
        fetchAllCallCount = 0
        searchCallCount = 0
        getCountryDetailsCallCount = 0
        getCountryDetailsByNameCallCount = 0
    }
}

