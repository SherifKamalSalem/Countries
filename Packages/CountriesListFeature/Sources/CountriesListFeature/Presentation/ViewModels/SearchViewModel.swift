//
//  SearchViewModel.swift
//  CountriesListFeature
//
//  Created by Sherif Kamal on 02/12/2025.
//


import Foundation
import Core
import Networking
import Combine

@MainActor
public final class SearchViewModel: ObservableObject {
    
    @Published public var searchQuery = ""
    @Published public private(set) var searchResults: [Country] = []
    @Published public private(set) var isSearching = false
    @Published public private(set) var error: Error?
    @Published public private(set) var hasSearched = false
    
    private let searchCountriesUseCase: SearchCountriesUseCase
    private var cancellables = Set<AnyCancellable>()
    private var searchTask: Task<Void, Never>?
   
    public init(searchCountriesUseCase: SearchCountriesUseCase) {
        self.searchCountriesUseCase = searchCountriesUseCase
        setupSearchDebounce()
    }
    
    private func setupSearchDebounce() {
        $searchQuery
            .debounce(for: .milliseconds(350), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(query: String) {
        searchTask?.cancel()
        
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmed.isEmpty else {
            searchResults = []
            hasSearched = false
            return
        }
        
        searchTask = Task {
            await search(query: trimmed)
        }
    }
    
    
    private func search(query: String) async {
        isSearching = true
        hasSearched = true
        error = nil
        
        do {
            let results = try await searchCountriesUseCase.execute(query: query)
            
            guard !Task.isCancelled else { return }
            
            searchResults = results
        } catch {
            guard !Task.isCancelled else { return }
            
            if let networkError = error as? NetworkError, case .notFound = networkError {
                searchResults = []
            } else {
                self.error = error
                searchResults = []
            }
        }
        
        isSearching = false
    }
    
    public func clear() {
        searchQuery = ""
        searchResults = []
        hasSearched = false
        error = nil
    }
}
