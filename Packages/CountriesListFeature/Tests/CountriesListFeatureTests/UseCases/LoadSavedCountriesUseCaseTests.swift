//
//  LoadSavedCountriesUseCaseTests.swift
//  CountriesListFeatureTests
//

import Testing
@testable import CountriesListFeature
import Core

struct LoadSavedCountriesUseCaseTests {
    
    @Test("Load empty list when no countries saved")
    func testLoadEmptyList() async {
        let mockStorage = MockStorageService()
        let useCase = LoadSavedCountriesUseCase(storageService: mockStorage)
        
        let countries = await useCase.execute()
        
        #expect(countries.isEmpty)
        #expect(mockStorage.loadCountriesCallCount == 1)
    }
    
    @Test("Load saved countries successfully")
    func testLoadSavedCountries() async {
        let mockStorage = MockStorageService()
        let useCase = LoadSavedCountriesUseCase(storageService: mockStorage)
        
        let country1 = Country.mock(id: "US", name: "United States")
        let country2 = Country.mock(id: "EG", name: "Egypt")
        await mockStorage.addCountry(country1)
        await mockStorage.addCountry(country2)
        
        let countries = await useCase.execute()
        
        #expect(countries.count == 2)
        #expect(countries.contains(where: { $0.id == "US" }))
        #expect(countries.contains(where: { $0.id == "EG" }))
        #expect(mockStorage.loadCountriesCallCount == 1)
    }
    
    @Test("Load multiple saved countries")
    func testLoadMultipleCountries() async {
        let mockStorage = MockStorageService()
        let useCase = LoadSavedCountriesUseCase(storageService: mockStorage)
        
        for i in 1...5 {
            let country = Country.mock(id: "\(i)", name: "Country \(i)")
            await mockStorage.addCountry(country)
        }
        
        let countries = await useCase.execute()
        
        #expect(countries.count == 5)
        #expect(mockStorage.loadCountriesCallCount == 1)
    }
}

