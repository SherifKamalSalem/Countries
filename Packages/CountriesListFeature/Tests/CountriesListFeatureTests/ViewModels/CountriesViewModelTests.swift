//
//  CountriesViewModelTests.swift
//  CountriesListFeatureTests
//

import Testing
@testable import CountriesListFeature
import Core

struct CountriesViewModelTests {
    
    @Test("Load saved countries successfully")
    func testLoadSavedCountries() async {
        let mockStorage = MockStorageService()
        
        let country1 = Country.mock(id: "US", name: "United States")
        let country2 = Country.mock(id: "EG", name: "Egypt")
        await mockStorage.addCountry(country1)
        await mockStorage.addCountry(country2)
        
        let loadUseCase = LoadSavedCountriesUseCase(storageService: mockStorage)
        let addUseCase = AddCountryUseCase(storageService: mockStorage)
        let removeUseCase = RemoveCountryUseCase(storageService: mockStorage)
        
        let mockLocation = MockLocationService()
        let mockRepository = MockCountriesRepository()
        let locationUseCase = GetCurrentLocationCountryUseCase(
            locationService: mockLocation,
            repository: mockRepository
        )
        
        let viewModel = await CountriesViewModel(
            loadSavedCountriesUseCase: loadUseCase,
            addCountryUseCase: addUseCase,
            removeCountryUseCase: removeUseCase,
            getCurrentLocationCountryUseCase: locationUseCase
        )
        
        await viewModel.loadSavedCountries()
        
        #expect(viewModel.savedCountries.count == 2)
        #expect(viewModel.isLoading == false)
    }
    
    @Test("Add country successfully")
    func testAddCountry() async {
        let mockStorage = MockStorageService()
        
        let loadUseCase = LoadSavedCountriesUseCase(storageService: mockStorage)
        let addUseCase = AddCountryUseCase(storageService: mockStorage)
        let removeUseCase = RemoveCountryUseCase(storageService: mockStorage)
        
        let mockLocation = MockLocationService()
        let mockRepository = MockCountriesRepository()
        let locationUseCase = GetCurrentLocationCountryUseCase(
            locationService: mockLocation,
            repository: mockRepository
        )
        
        let viewModel = await CountriesViewModel(
            loadSavedCountriesUseCase: loadUseCase,
            addCountryUseCase: addUseCase,
            removeCountryUseCase: removeUseCase,
            getCurrentLocationCountryUseCase: locationUseCase
        )
        
        let country = Country.mock(id: "US", name: "United States")
        let success = await viewModel.addCountry(country)
        
        #expect(success == true)
        #expect(viewModel.savedCountries.count == 1)
        #expect(viewModel.error == nil)
        #expect(viewModel.showError == false)
    }
    
    @Test("Show error when limit reached")
    func testAddCountryLimitReached() async {
        let mockStorage = MockStorageService()
        
        let loadUseCase = LoadSavedCountriesUseCase(storageService: mockStorage)
        let addUseCase = AddCountryUseCase(storageService: mockStorage)
        let removeUseCase = RemoveCountryUseCase(storageService: mockStorage)
        
        let mockLocation = MockLocationService()
        let mockRepository = MockCountriesRepository()
        let locationUseCase = GetCurrentLocationCountryUseCase(
            locationService: mockLocation,
            repository: mockRepository
        )
        
        let viewModel = await CountriesViewModel(
            loadSavedCountriesUseCase: loadUseCase,
            addCountryUseCase: addUseCase,
            removeCountryUseCase: removeUseCase,
            getCurrentLocationCountryUseCase: locationUseCase
        )
        
        for i in 1...5 {
            let country = Country.mock(id: "\(i)", name: "Country \(i)")
            _ = await viewModel.addCountry(country)
        }
        
        let newCountry = Country.mock(id: "6", name: "Country 6")
        let success = await viewModel.addCountry(newCountry)
        
        #expect(success == false)
        #expect(viewModel.savedCountries.count == 5)
        #expect(viewModel.showError == true)
        #expect(viewModel.error != nil)
    }
    
    @Test("Remove country successfully")
    func testRemoveCountry() async {
        let mockStorage = MockStorageService()
        
        let loadUseCase = LoadSavedCountriesUseCase(storageService: mockStorage)
        let addUseCase = AddCountryUseCase(storageService: mockStorage)
        let removeUseCase = RemoveCountryUseCase(storageService: mockStorage)
        
        let mockLocation = MockLocationService()
        let mockRepository = MockCountriesRepository()
        let locationUseCase = GetCurrentLocationCountryUseCase(
            locationService: mockLocation,
            repository: mockRepository
        )
        
        let viewModel = await CountriesViewModel(
            loadSavedCountriesUseCase: loadUseCase,
            addCountryUseCase: addUseCase,
            removeCountryUseCase: removeUseCase,
            getCurrentLocationCountryUseCase: locationUseCase
        )
        
        let country1 = Country.mock(id: "US", name: "United States")
        let country2 = Country.mock(id: "EG", name: "Egypt")
        
        _ = await viewModel.addCountry(country1)
        _ = await viewModel.addCountry(country2)
        
        #expect(viewModel.savedCountries.count == 2)
        
        await viewModel.removeCountry(country1)
        
        #expect(viewModel.savedCountries.count == 1)
        #expect(viewModel.savedCountries.first?.id == "EG")
    }
    
    @Test("Can add more countries when under limit")
    func testCanAddMoreCountries() async {
        let mockStorage = MockStorageService()
        
        let loadUseCase = LoadSavedCountriesUseCase(storageService: mockStorage)
        let addUseCase = AddCountryUseCase(storageService: mockStorage)
        let removeUseCase = RemoveCountryUseCase(storageService: mockStorage)
        
        let mockLocation = MockLocationService()
        let mockRepository = MockCountriesRepository()
        let locationUseCase = GetCurrentLocationCountryUseCase(
            locationService: mockLocation,
            repository: mockRepository
        )
        
        let viewModel = await CountriesViewModel(
            loadSavedCountriesUseCase: loadUseCase,
            addCountryUseCase: addUseCase,
            removeCountryUseCase: removeUseCase,
            getCurrentLocationCountryUseCase: locationUseCase
        )
        
        #expect(viewModel.canAddMoreCountries == true)
        #expect(viewModel.countryCount == 0)
        
        for i in 1...3 {
            let country = Country.mock(id: "\(i)", name: "Country \(i)")
            _ = await viewModel.addCountry(country)
        }
        
        #expect(viewModel.canAddMoreCountries == true)
        #expect(viewModel.countryCount == 3)
        
        for i in 4...5 {
            let country = Country.mock(id: "\(i)", name: "Country \(i)")
            _ = await viewModel.addCountry(country)
        }
        
        #expect(viewModel.canAddMoreCountries == false)
        #expect(viewModel.countryCount == 5)
    }
    
    @Test("Dismiss error successfully")
    func testDismissError() async {
        let mockStorage = MockStorageService()
        
        let loadUseCase = LoadSavedCountriesUseCase(storageService: mockStorage)
        let addUseCase = AddCountryUseCase(storageService: mockStorage)
        let removeUseCase = RemoveCountryUseCase(storageService: mockStorage)
        
        let mockLocation = MockLocationService()
        let mockRepository = MockCountriesRepository()
        let locationUseCase = GetCurrentLocationCountryUseCase(
            locationService: mockLocation,
            repository: mockRepository
        )
        
        let viewModel = await CountriesViewModel(
            loadSavedCountriesUseCase: loadUseCase,
            addCountryUseCase: addUseCase,
            removeCountryUseCase: removeUseCase,
            getCurrentLocationCountryUseCase: locationUseCase
        )
        
        for i in 1...5 {
            let country = Country.mock(id: "\(i)", name: "Country \(i)")
            _ = await viewModel.addCountry(country)
        }
        
        let newCountry = Country.mock(id: "6", name: "Country 6")
        _ = await viewModel.addCountry(newCountry)
        
        #expect(viewModel.showError == true)
        #expect(viewModel.error != nil)
        
        await viewModel.dismissError()
        
        #expect(viewModel.showError == false)
        #expect(viewModel.error == nil)
    }
    
    @Test("Load empty list and add current location country")
    func testLoadEmptyAndAddCurrentLocation() async {
        let mockStorage = MockStorageService()
        
        let loadUseCase = LoadSavedCountriesUseCase(storageService: mockStorage)
        let addUseCase = AddCountryUseCase(storageService: mockStorage)
        let removeUseCase = RemoveCountryUseCase(storageService: mockStorage)
        
        let mockLocation = MockLocationService()
        let mockRepository = MockCountriesRepository()
        
        mockLocation.countryCode = "EG"
        let egyptCountry = Country.mock(id: "EG", name: "Egypt")
        mockRepository.countryDetails["EG"] = egyptCountry
        
        let locationUseCase = GetCurrentLocationCountryUseCase(
            locationService: mockLocation,
            repository: mockRepository
        )
        
        let viewModel = await CountriesViewModel(
            loadSavedCountriesUseCase: loadUseCase,
            addCountryUseCase: addUseCase,
            removeCountryUseCase: removeUseCase,
            getCurrentLocationCountryUseCase: locationUseCase
        )
        
        await viewModel.loadSavedCountries()
        
        #expect(viewModel.savedCountries.count == 1)
        #expect(viewModel.savedCountries.first?.id == "EG")
    }
}

