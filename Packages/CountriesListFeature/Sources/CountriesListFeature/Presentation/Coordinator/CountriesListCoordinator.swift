//
//  CountriesListCoordinator.swift
//  CountriesListFeature
//
//  Created by Sherif Kamal on 02/12/2025.
//

import Foundation
import Core
import Navigation
import Storage
import Location
import Networking

@MainActor
public final class CountriesListCoordinator: ObservableObject {
    
    private let router: Router
    private let container: DependencyContainer
    
    public private(set) lazy var countriesViewModel: CountriesViewModel = {
        let vm = makeCountriesViewModel()
        vm.delegate = self
        return vm
    }()
    
    public private(set) lazy var searchViewModel: SearchViewModel = {
        let vm = makeSearchViewModel()
        vm.delegate = self
        return vm
    }()
    
    public init(router: Router, container: DependencyContainer = .shared) {
        self.router = router
        self.container = container
    }
    
    private func makeCountriesViewModel() -> CountriesViewModel {
        let storageService: StorageServiceProtocol = container.resolve()
        let locationService: LocationServiceProtocol = container.resolve()
        let networkService: NetworkServiceProtocol = container.resolve()
        
        let repository = CountriesRepository(
            networkService: networkService,
            storageService: storageService
        )
        
        return CountriesViewModel(
            loadSavedCountriesUseCase: LoadSavedCountriesUseCase(storageService: storageService),
            addCountryUseCase: AddCountryUseCase(storageService: storageService),
            removeCountryUseCase: RemoveCountryUseCase(storageService: storageService),
            getCurrentLocationCountryUseCase: GetCurrentLocationCountryUseCase(
                locationService: locationService,
                repository: repository
            )
        )
    }
    
    private func makeSearchViewModel() -> SearchViewModel {
        let storageService: StorageServiceProtocol = container.resolve()
        let networkService: NetworkServiceProtocol = container.resolve()
        
        let repository = CountriesRepository(
            networkService: networkService,
            storageService: storageService
        )
        
        return SearchViewModel(
            searchCountriesUseCase: SearchCountriesUseCase(repository: repository)
        )
    }
    
     public func handleCountrySelection(_ country: Country) async {
        let added = await countriesViewModel.addCountry(country)
        if added {
            router.dismiss()
            searchViewModel.clear()
        }
    }
}

extension CountriesListCoordinator: CountriesViewModelDelegate {
    
    public func countriesViewModelDidRequestSearch(_ viewModel: CountriesViewModel) {
        router.present(sheet: .search)
    }
    
    public func countriesViewModel(_ viewModel: CountriesViewModel, didSelectCountry country: Country) {
        router.navigate(to: .countryDetail(country))
    }
}

extension CountriesListCoordinator: SearchViewModelDelegate {
    
    public func searchViewModel(_ viewModel: SearchViewModel, didSelectCountry country: Country) {
        Task {
            await handleCountrySelection(country)
        }
    }
    
    public func searchViewModelDidRequestDismiss(_ viewModel: SearchViewModel) {
        router.dismiss()
        searchViewModel.clear()
    }
}

