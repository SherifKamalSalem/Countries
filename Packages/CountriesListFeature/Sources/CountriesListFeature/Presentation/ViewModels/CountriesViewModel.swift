//
//  CountriesViewModel.swift
//  CountriesListFeature
//
//  Created by Sherif Kamal on 02/12/2025.
//

import Foundation
import Core

public protocol CountriesViewModelDelegate: AnyObject, Sendable {
    @MainActor func countriesViewModelDidRequestSearch(_ viewModel: CountriesViewModel)
    @MainActor func countriesViewModel(_ viewModel: CountriesViewModel, didSelectCountry country: Country)
}

@Observable
@MainActor
public final class CountriesViewModel {
    
    public private(set) var savedCountries: [Country] = []
    public private(set) var isLoading = false
    public private(set) var error: Error?
    public var showError = false
    
    public var canAddMoreCountries: Bool {
        savedCountries.count < maxCountries
    }
    
    public var countryCount: Int {
        savedCountries.count
    }
    
    private let maxCountries = 5
    
    private let loadSavedCountriesUseCase: LoadSavedCountriesUseCase
    private let addCountryUseCase: AddCountryUseCase
    private let removeCountryUseCase: RemoveCountryUseCase
    private let getCurrentLocationCountryUseCase: GetCurrentLocationCountryUseCase
    
    public weak var delegate: CountriesViewModelDelegate?
    
    public init(
        loadSavedCountriesUseCase: LoadSavedCountriesUseCase,
        addCountryUseCase: AddCountryUseCase,
        removeCountryUseCase: RemoveCountryUseCase,
        getCurrentLocationCountryUseCase: GetCurrentLocationCountryUseCase
    ) {
        self.loadSavedCountriesUseCase = loadSavedCountriesUseCase
        self.addCountryUseCase = addCountryUseCase
        self.removeCountryUseCase = removeCountryUseCase
        self.getCurrentLocationCountryUseCase = getCurrentLocationCountryUseCase
    }
    
    public func loadSavedCountries() async {
        isLoading = true
        defer { isLoading = false }
        
        savedCountries = await loadSavedCountriesUseCase.execute()
        
        if savedCountries.isEmpty {
            await addCurrentLocationCountry()
            savedCountries = await loadSavedCountriesUseCase.execute()
        }
    }
    
    public func addCountry(_ country: Country) async -> Bool {
        let result = await addCountryUseCase.execute(country: country)
        
        switch result {
        case .added, .alreadyExists:
            savedCountries = await loadSavedCountriesUseCase.execute()
            return true
            
        case .limitReached:
            error = CountriesError.limitReached
            showError = true
            return false
        }
    }
    
    public func removeCountry(_ country: Country) async {
        await removeCountryUseCase.execute(countryId: country.id)
        savedCountries = await loadSavedCountriesUseCase.execute()
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
    
    public func requestSearch() {
        delegate?.countriesViewModelDidRequestSearch(self)
    }
    
    public func selectCountry(_ country: Country) {
        delegate?.countriesViewModel(self, didSelectCountry: country)
    }
    
    public func dismissError() {
        showError = false
        error = nil
    }
    
    private func addCurrentLocationCountry() async {
        let result = await getCurrentLocationCountryUseCase.execute()
        
        switch result {
        case .success(let country):
            _ = await addCountryUseCase.execute(country: country)
            
        case .locationDenied, .countryNotFound, .error:
            #if DEBUG
            debugPrint("Failed to add current location country: \(result)")
            #endif
        }
    }
}
