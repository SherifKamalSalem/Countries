//
//  CountriesViewModel.swift
//  CountriesListFeature
//
//  Created by Sherif Kamal on 02/12/2025.
//


import Foundation
import Combine
import Core
import Storage
import Location

/// ViewModel for the main countries list screen
@MainActor
@Observable
public final class CountriesViewModel {
    
    // MARK: - Published State
    public private(set) var savedCountries: [Country] = []
    public private(set) var isLoading = false
    public private(set) var error: Error?
    public var showError = false
    
    // MARK: - Dependencies
    private let repository: CountriesRepositoryProtocol
    private let storageService: StorageServiceProtocol
    private let locationService: LocationServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    public init(
        repository: CountriesRepositoryProtocol,
        storageService: StorageServiceProtocol,
        locationService: LocationServiceProtocol
    ) {
        self.repository = repository
        self.storageService = storageService
        self.locationService = locationService
    }
    
    public func loadSavedCountries() async {
        savedCountries = await storageService.loadCountries()
        
        if savedCountries.isEmpty {
            await addCurrentLocationCountry()
        }
    }
    
    public func addCountry(_ country: Country) async -> Bool {
        guard savedCountries.count < 5 else {
            error = CountriesError.limitReached
            showError = true
            return false
        }
        
        let added = await storageService.addCountry(country)
        if added {
            savedCountries = await storageService.loadCountries()
        }
        return added
    }
    
    public func removeCountry(_ country: Country) async {
        await storageService.removeCountry(id: country.id)
        savedCountries = await storageService.loadCountries()
    }
    
    public func removeCountry(at offsets: IndexSet) {
        Task {
            for index in offsets {
                if let country = savedCountries[safe: index] {
                    await removeCountry(country)
                }
            }
        }
    }
    
    private func addCurrentLocationCountry() async {
        do {
            let countryCode = try await locationService.getCurrentCountryCode()
            
            let countries = try await repository.searchCountries(by: countryCode)
            
            if let country = countries.first {
                _ = await storageService.addCountry(country)
                savedCountries = await storageService.loadCountries()
            }
        } catch {
            await addDefaultCountry()
        }
    }
    
    private func addDefaultCountry() async {
        do {
            let countries = try await repository.searchCountries(by: "Egypt")
            if let egypt = countries.first {
                _ = await storageService.addCountry(egypt)
                savedCountries = await storageService.loadCountries()
            }
        } catch {
            #if DEBUG
            debugPrint("Failed to add default country: \(error)")
            #endif
        }
    }
    
    public func dismissError() {
        showError = false
        error = nil
    }
}

