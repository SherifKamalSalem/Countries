//
//  AppRootView.swift
//  Countries
//

import SwiftUI
import CountriesListFeature
import CountryDetailsFeature
import Navigation

struct AppRootView: View {
    
    @StateObject private var appCoordinator = AppCoordinator()
    @StateObject private var countriesListCoordinator: CountriesListCoordinator
    @StateObject private var countryDetailCoordinator: CountryDetailCoordinator
    
    init() {
        let coordinator = AppCoordinator()
        _appCoordinator = StateObject(wrappedValue: coordinator)
        _countriesListCoordinator = StateObject(wrappedValue: CountriesListCoordinator(router: coordinator))
        _countryDetailCoordinator = StateObject(wrappedValue: CountryDetailCoordinator())
    }
    
    var body: some View {
        NavigationStack(path: $appCoordinator.path) {
            CountriesListRootView(coordinator: countriesListCoordinator)
                .navigationDestination(for: AppRoute.self) { route in
                    destinationView(for: route)
                }
        }
        .sheet(item: $appCoordinator.presentedSheet) { sheet in
            sheetView(for: sheet)
        }
        .fullScreenCover(item: $appCoordinator.fullScreenCover) { sheet in
            sheetView(for: sheet)
        }
        .environment(\.container, .shared)
    }
    
    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .countriesList:
            CountriesListView(coordinator: countriesListCoordinator)
            
        case .countryDetail(let country):
            CountryDetailView(
                viewModel: countryDetailCoordinator.makeCountryDetailViewModel(for: country)
            )
        }
    }
    
    @ViewBuilder
    private func sheetView(for sheet: Sheet) -> some View {
        switch sheet {
        case .search:
            SearchView(viewModel: countriesListCoordinator.searchViewModel)
            
        case .countryPicker:
            SearchView(viewModel: countriesListCoordinator.searchViewModel)
        }
    }
}

