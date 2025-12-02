//
//  CountriesListRootView.swift
//  CountriesListFeature
//
//  Created by Sherif Kamal on 02/12/2025.
//

import SwiftUI
import Core
import DesignSystem
import Navigation

public struct CountriesListRootView: View {
    
    @ObservedObject private var appCoordinator: AppCoordinator
    @StateObject private var featureCoordinator: CountriesListCoordinator
    
    public init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
        self._featureCoordinator = StateObject(wrappedValue: CountriesListCoordinator(router: appCoordinator))
    }
    
    public var body: some View {
        NavigationStack(path: $appCoordinator.path) {
            CountriesListView(coordinator: featureCoordinator)
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
    }
    
    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .countriesList:
            CountriesListView(coordinator: featureCoordinator)
            
        case .countryDetail(let country):
            CountryDetailPlaceholderView(country: country)
        }
    }
    
    @ViewBuilder
    private func sheetView(for sheet: Sheet) -> some View {
        switch sheet {
        case .search:
            SearchView(viewModel: featureCoordinator.searchViewModel)
            
        case .countryPicker:
            SearchView(viewModel: featureCoordinator.searchViewModel)
        }
    }
}

private struct CountryDetailPlaceholderView: View {
    let country: Country
    
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            if let flagURL = country.flagURL {
                AsyncImage(url: flagURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            Text(country.name)
                .font(AppTypography.title)
                .foregroundStyle(AppColors.textPrimary)
            
            if let capital = country.capital {
                Text("Capital: \(capital)")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textSecondary)
            }
            
            if let currency = country.currencies.first {
                Text("Currency: \(currency.name) (\(currency.symbol))")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textSecondary)
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(AppColors.background)
        .navigationTitle(country.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

