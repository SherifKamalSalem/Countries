//
//  AddCountryUseCaseTests.swift
//  CountriesListFeatureTests
//

import Testing
@testable import CountriesListFeature
import Core

struct AddCountryUseCaseTests {
    
    @Test("Add country successfully when under limit")
    func testAddCountrySuccess() async {
        let mockStorage = MockStorageService()
        let useCase = AddCountryUseCase(storageService: mockStorage)
        let country = Country.mock(id: "US", name: "United States")
        
        let result = await useCase.execute(country: country)
        
        #expect(result == .added)
        #expect(mockStorage.addCountryCallCount == 1)
        #expect(await mockStorage.loadCountries().count == 1)
    }
    
    @Test("Return alreadyExists when country is already in list")
    func testAddCountryAlreadyExists() async {
        let mockStorage = MockStorageService()
        let useCase = AddCountryUseCase(storageService: mockStorage)
        let country = Country.mock(id: "US", name: "United States")
        
        _ = await useCase.execute(country: country)
        
        let result = await useCase.execute(country: country)
        
        #expect(result == .alreadyExists)
        #expect(await mockStorage.loadCountries().count == 1)
    }
    
    @Test("Return limitReached when trying to add 6th country")
    func testAddCountryLimitReached() async {
        let mockStorage = MockStorageService()
        let useCase = AddCountryUseCase(storageService: mockStorage)
        
        for i in 1...5 {
            let country = Country.mock(id: "\(i)", name: "Country \(i)")
            _ = await useCase.execute(country: country)
        }
        
        let newCountry = Country.mock(id: "6", name: "Country 6")
        let result = await useCase.execute(country: newCountry)
        
        #expect(result == .limitReached)
        #expect(await mockStorage.loadCountries().count == 5)
    }
    
    @Test("Can add exactly 5 countries")
    func testAddExactlyFiveCountries() async {
        let mockStorage = MockStorageService()
        let useCase = AddCountryUseCase(storageService: mockStorage)
        
        var results: [AddCountryUseCase.Result] = []
        for i in 1...5 {
            let country = Country.mock(id: "\(i)", name: "Country \(i)")
            let result = await useCase.execute(country: country)
            results.append(result)
        }
        
        #expect(results.allSatisfy { $0 == .added })
        #expect(await mockStorage.loadCountries().count == 5)
    }
}

