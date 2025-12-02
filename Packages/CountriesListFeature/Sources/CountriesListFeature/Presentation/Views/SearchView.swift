//
//  SearchView.swift
//  CountriesListFeature
//
//  Created by Sherif Kamal on 02/12/2025.
//


import SwiftUI
import Core
import DesignSystem

struct SearchView: View {
    
    @State private var viewModel: SearchViewModel
    @State private var debounceTask: Task<Void, Never>?
    @Environment(\.dismiss) private var dismiss
    
    let onCountrySelected: (Country) -> Void
    
    init(searchCountriesUseCase: SearchCountriesUseCase, onCountrySelected: @escaping (Country) -> Void) {
        _viewModel = State(initialValue: SearchViewModel(searchCountriesUseCase: searchCountriesUseCase))
        self.onCountrySelected = onCountrySelected
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    SearchBarView(
                        text: $viewModel.searchQuery,
                        placeholder: "Search countries..."
                    )
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.top, AppSpacing.sm)
                    
                    if viewModel.isSearching {
                        loadingView
                    } else if let error = viewModel.error {
                        errorView(error)
                    } else if viewModel.searchResults.isEmpty && viewModel.hasSearched {
                        noResultsView
                    } else if viewModel.searchResults.isEmpty {
                        promptView
                    } else {
                        resultsList
                    }
                }
            }
            .navigationTitle("Add Country")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: AppColors.primary))
            Text("Searching...")
                .font(AppTypography.subheadline)
                .foregroundStyle(AppColors.textSecondary)
                .padding(.top, AppSpacing.sm)
            Spacer()
        }
    }
    
    private func errorView(_ error: Error) -> some View {
        VStack {
            Spacer()
            ErrorView(
                message: error.localizedDescription,
                retryAction: nil
            )
            Spacer()
        }
    }
    
    private var noResultsView: some View {
        VStack {
            Spacer()
            EmptyStateView(
                icon: "magnifyingglass",
                title: "No Results",
                subtitle: "No countries found matching \"\(viewModel.searchQuery)\""
            )
            Spacer()
        }
    }
    
    private var promptView: some View {
        VStack {
            Spacer()
            Image(systemName: "globe")
                .font(.system(size: 56))
                .foregroundStyle(AppColors.primary.opacity(0.4))
            Text("Search for a country")
                .font(AppTypography.subheadline)
                .foregroundStyle(AppColors.textSecondary)
                .padding(.top, AppSpacing.sm)
            Spacer()
        }
    }
    
    private var resultsList: some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.sm) {
                ForEach(viewModel.searchResults) { country in
                    CountryCardView(
                        name: country.name,
                        capital: country.capital,
                        currencyCode: country.currencies.first?.code,
                        flagURL: country.flagURL,
                        onTap: {
                            onCountrySelected(country)
                        }
                    )
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.top, AppSpacing.sm)
        }
    }
}
