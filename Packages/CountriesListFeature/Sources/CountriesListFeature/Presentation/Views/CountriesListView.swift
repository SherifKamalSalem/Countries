//
//  CountriesListView.swift
//  CountriesListFeature
//
//  Created by Sherif Kamal on 02/12/2025.
//

import SwiftUI
import Core
import DesignSystem
import Navigation

public struct CountriesListView: View {
    
    @ObservedObject private var coordinator: CountriesListCoordinator
    
    public init(coordinator: CountriesListCoordinator) {
        self.coordinator = coordinator
    }
    
    public var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            if coordinator.countriesViewModel.isLoading {
                SkeletonCountriesListView(itemCount: 3)
            } else if coordinator.countriesViewModel.savedCountries.isEmpty {
                emptyState
            } else {
                countriesList
            }
        }
        .navigationTitle("My Countries")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if coordinator.countriesViewModel.canAddMoreCountries {
                    addButton
                }
            }
        }
        .alert("Error", isPresented: .init(
            get: { coordinator.countriesViewModel.showError },
            set: { _ in coordinator.countriesViewModel.dismissError() }
        )) {
            Button("OK") {
                coordinator.countriesViewModel.dismissError()
            }
        } message: {
            Text(coordinator.countriesViewModel.error?.localizedDescription ?? "An error occurred")
        }
        .task {
            await coordinator.countriesViewModel.loadSavedCountries()
        }
    }
    
    private var addButton: some View {
        Button {
            coordinator.countriesViewModel.requestSearch()
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 16, weight: .semibold))
        }
    }
    
    private var countriesList: some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.sm) {
                ForEach(coordinator.countriesViewModel.savedCountries) { country in
                    CountryCardView(
                        name: country.name,
                        capital: country.capital,
                        currencyCode: country.currencies.first?.code,
                        flagURL: country.flagURL,
                        onTap: {
                            coordinator.countriesViewModel.selectCountry(country)
                        }
                    )
                    .contextMenu {
                        Button(role: .destructive) {
                            Task {
                                await coordinator.countriesViewModel.removeCountry(country)
                            }
                        } label: {
                            Label("Remove", systemImage: "trash")
                        }
                    }
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.top, AppSpacing.xs)
        }
    }
    
    private var emptyState: some View {
        EmptyStateView(
            icon: "globe.europe.africa",
            title: "No Countries Yet",
            subtitle: "Tap the + button to search and add countries to your list.",
            actionTitle: "Add Country",
            action: {
                coordinator.countriesViewModel.requestSearch()
            }
        )
    }
}

