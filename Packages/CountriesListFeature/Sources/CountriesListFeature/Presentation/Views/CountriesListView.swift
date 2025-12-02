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
import Networking
import Storage

public struct CountriesListView: View {
    
    @State private var viewModel: CountriesViewModel
    @ObservedObject private var coordinator: AppCoordinator
    
    @State private var showSearch = false
    
    private let networkService: NetworkServiceProtocol
    private let storageService: StorageServiceProtocol
    
    public init(
        viewModel: CountriesViewModel,
        coordinator: AppCoordinator,
        networkService: NetworkServiceProtocol? = nil,
        storageService: StorageServiceProtocol? = nil
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        self.networkService = networkService ?? NetworkService()
        self.storageService = storageService ?? StorageService()
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                if viewModel.savedCountries.isEmpty {
                    emptyState
                } else {
                    countriesList
                }
            }
            .navigationTitle("My Countries")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.savedCountries.count < 5 {
                        Button {
                            showSearch = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK") {
                    viewModel.dismissError()
                }
            } message: {
                Text(viewModel.error?.localizedDescription ?? "An error occurred")
            }
        }
        .task {
            await viewModel.loadSavedCountries()
        }
    }
    
    // MARK: - Views
    
    private var countriesList: some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.sm) {
                ForEach(viewModel.savedCountries) { country in
                    CountryCardView(
                        name: country.name,
                        capital: country.capital,
                        currencyCode: country.currencies.first?.code,
                        flagURL: country.flagURL,
                        onTap: {
                            coordinator.navigate(to: .countryDetail(country))
                        }
                    )
                    .contextMenu {
                        Button(role: .destructive) {
                            Task {
                                await viewModel.removeCountry(country)
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
                showSearch = true
            }
        )
    }
    
    private func makeRepository() -> CountriesRepositoryProtocol {
        CountriesRepository(
            networkService: networkService,
            storageService: storageService
        )
    }
}

