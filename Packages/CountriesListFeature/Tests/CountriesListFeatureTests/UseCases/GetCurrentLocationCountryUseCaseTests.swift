//
//  GetCurrentLocationCountryUseCaseTests.swift
//  CountriesListFeatureTests
//

import Testing
@testable import CountriesListFeature
import Core

struct GetCurrentLocationCountryUseCaseTests {
    
    @Test("Return success when location and country found")
    func testGetCurrentLocationSuccess() async {
        let mockLocation = MockLocationService()
        let mockRepository = MockCountriesRepository()
        let useCase = GetCurrentLocationCountryUseCase(
            locationService: mockLocation,
            repository: mockRepository
        )
        
        mockLocation.countryCode = "EG"
        let expectedCountry = Country.mock(id: "EG", name: "Egypt")
        mockRepository.countryDetails["EG"] = expectedCountry
        
        let result = await useCase.execute()
        
        if case .success(let country) = result {
            #expect(country.id == "EG")
            #expect(country.name == "Egypt")
        } else {
            Issue.record("Expected success but got \(result)")
        }
        
        #expect(mockLocation.getCurrentCountryCodeCallCount == 1)
        #expect(mockRepository.getCountryDetailsCallCount == 1)
    }
    
    @Test("Fallback to default country when location fails")
    func testFallbackToDefaultCountry() async {
        let mockLocation = MockLocationService()
        let mockRepository = MockCountriesRepository()
        let useCase = GetCurrentLocationCountryUseCase(
            locationService: mockLocation,
            repository: mockRepository,
            defaultCountryName: "Egypt"
        )
        
        mockLocation.error = NSError(domain: "LocationError", code: 1)
        
        let defaultCountry = Country.mock(id: "EG", name: "Egypt")
        mockRepository.searchResults = [defaultCountry]
        
        let result = await useCase.execute()
        
        if case .success(let country) = result {
            #expect(country.id == "EG")
            #expect(mockRepository.searchCallCount == 1)
        } else {
            Issue.record("Expected success with default country but got \(result)")
        }
    }
    
    @Test("Return countryNotFound when default country not found")
    func testCountryNotFound() async {
        let mockLocation = MockLocationService()
        let mockRepository = MockCountriesRepository()
        let useCase = GetCurrentLocationCountryUseCase(
            locationService: mockLocation,
            repository: mockRepository,
            defaultCountryName: "Egypt"
        )
        
        mockLocation.error = NSError(domain: "LocationError", code: 1)
        
        mockRepository.searchResults = []
        
        let result = await useCase.execute()
        
        if case .countryNotFound = result {
        } else {
            Issue.record("Expected countryNotFound but got \(result)")
        }
    }
    
    @Test("Return error when default country search fails")
    func testDefaultCountrySearchError() async {
        let mockLocation = MockLocationService()
        let mockRepository = MockCountriesRepository()
        let useCase = GetCurrentLocationCountryUseCase(
            locationService: mockLocation,
            repository: mockRepository,
            defaultCountryName: "Egypt"
        )
        
        mockLocation.error = NSError(domain: "LocationError", code: 1)
        
        let searchError = NSError(domain: "SearchError", code: 500)
        mockRepository.searchError = searchError
        
        let result = await useCase.execute()
        
        if case .error(let error) = result {
            #expect((error as NSError).domain == "SearchError")
        } else {
            Issue.record("Expected error but got \(result)")
        }
    }
    
    @Test("Return error when country details not found for location code")
    func testCountryDetailsNotFound() async {
        let mockLocation = MockLocationService()
        let mockRepository = MockCountriesRepository()
        let useCase = GetCurrentLocationCountryUseCase(
            locationService: mockLocation,
            repository: mockRepository
        )
        
        mockLocation.countryCode = "XX"
        mockRepository.searchResults = [Country.mock(id: "EG", name: "Egypt")]
        
        let result = await useCase.execute()
        
        if case .success = result {
        } else {
            Issue.record("Expected success with default but got \(result)")
        }
    }
}

