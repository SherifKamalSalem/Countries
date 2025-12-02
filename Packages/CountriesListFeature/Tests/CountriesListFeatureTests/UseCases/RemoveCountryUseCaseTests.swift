//
//  RemoveCountryUseCaseTests.swift
//  CountriesListFeatureTests
//

import Testing
@testable import CountriesListFeature
import Core

struct RemoveCountryUseCaseTests {
    
    @Test("Remove country successfully")
    func testRemoveCountry() async {
        let mockStorage = MockStorageService()
        let useCase = RemoveCountryUseCase(storageService: mockStorage)
        
        let country = Country.mock(id: "US", name: "United States")
        await mockStorage.addCountry(country)
        #expect(await mockStorage.loadCountries().count == 1)
        
        await useCase.execute(countryId: "US")
        
        #expect(await mockStorage.loadCountries().isEmpty)
        #expect(mockStorage.removeCountryCallCount == 1)
    }
    
    @Test("Remove specific country from multiple countries")
    func testRemoveSpecificCountry() async {
        let mockStorage = MockStorageService()
        let useCase = RemoveCountryUseCase(storageService: mockStorage)
        
        let country1 = Country.mock(id: "US", name: "United States")
        let country2 = Country.mock(id: "EG", name: "Egypt")
        let country3 = Country.mock(id: "GB", name: "United Kingdom")
        
        await mockStorage.addCountry(country1)
        await mockStorage.addCountry(country2)
        await mockStorage.addCountry(country3)
        
        #expect(await mockStorage.loadCountries().count == 3)
        
        await useCase.execute(countryId: "EG")
        
        let remaining = await mockStorage.loadCountries()
        #expect(remaining.count == 2)
        #expect(remaining.contains(where: { $0.id == "US" }))
        #expect(remaining.contains(where: { $0.id == "GB" }))
        #expect(!remaining.contains(where: { $0.id == "EG" }))
    }
    
    @Test("Remove non-existent country does not crash")
    func testRemoveNonExistentCountry() async {
        let mockStorage = MockStorageService()
        let useCase = RemoveCountryUseCase(storageService: mockStorage)
        
        await useCase.execute(countryId: "XX")
        
        #expect(await mockStorage.loadCountries().isEmpty)
        #expect(mockStorage.removeCountryCallCount == 1)
    }
}

