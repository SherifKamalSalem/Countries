//
//  SearchView.swift
//  CountriesListFeature
//
//  Created by Sherif Kamal on 02/12/2025.
//

import SwiftUI
import Core
import DesignSystem

public struct SearchView: View {
    
    @ObservedObject private var viewModel: SearchViewModel
    
    public init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
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
                    
                    contentView
                }
            }
            .navigationTitle("Add Country")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        viewModel.requestDismiss()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
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
    
    private var loadingView: some View {
        SkeletonCountriesListView(itemCount: 3)
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
                            viewModel.selectCountry(country)
                        }
                    )
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.top, AppSpacing.sm)
        }
    }
}
