//
//  SearchViewModelTests.swift
//  CountriesListFeatureTests
//

import Testing
@testable import CountriesListFeature
import Core

struct SearchViewModelTests {
    
    @Test("Search with valid query returns results")
    func testSearchWithValidQuery() async {
        let mockRepository = MockCountriesRepository()
        let searchUseCase = SearchCountriesUseCase(repository: mockRepository)
        
        let expectedResults = [
            Country.mock(id: "EG", name: "Egypt"),
            Country.mock(id: "ET", name: "Ethiopia")
        ]
        mockRepository.searchResults = expectedResults
        
        let viewModel = await SearchViewModel(searchCountriesUseCase: searchUseCase)
        
        viewModel.searchQuery = "Eg"
        
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        var attempts = 0
        while viewModel.isSearching && attempts < 10 {
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
            attempts += 1
        }
        
        #expect(viewModel.searchResults.count == 2)
        #expect(viewModel.hasSearched == true)
        #expect(viewModel.isSearching == false)
    }
    
    @Test("Search with empty query clears results")
    func testSearchWithEmptyQuery() async {
        let mockRepository = MockCountriesRepository()
        let searchUseCase = SearchCountriesUseCase(repository: mockRepository)
        
        let viewModel = await SearchViewModel(searchCountriesUseCase: searchUseCase)
        
        viewModel.searchQuery = "Egypt"
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        var attempts = 0
        while viewModel.isSearching && attempts < 10 {
            try? await Task.sleep(nanoseconds: 100_000_000)
            attempts += 1
        }
        
        viewModel.searchQuery = ""
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        #expect(viewModel.searchResults.isEmpty)
        #expect(viewModel.hasSearched == false)
    }
    
    @Test("Search with query shorter than minimum does not search")
    func testSearchWithShortQuery() async {
        let mockRepository = MockCountriesRepository()
        let searchUseCase = SearchCountriesUseCase(repository: mockRepository)
        
        let viewModel = await SearchViewModel(searchCountriesUseCase: searchUseCase)
        
        viewModel.searchQuery = "E"
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        var attempts = 0
        while viewModel.isSearching && attempts < 10 {
            try? await Task.sleep(nanoseconds: 100_000_000)
            attempts += 1
        }
        
        #expect(mockRepository.searchCallCount == 0)
        #expect(viewModel.searchResults.isEmpty)
    }
    
    @Test("Search sets error when repository throws")
    func testSearchSetsError() async {
        let mockRepository = MockCountriesRepository()
        let searchUseCase = SearchCountriesUseCase(repository: mockRepository)
        
        let testError = NSError(domain: "TestError", code: 500)
        mockRepository.searchError = testError
        
        let viewModel = await SearchViewModel(searchCountriesUseCase: searchUseCase)
        
        viewModel.searchQuery = "Egypt"
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        var attempts = 0
        while viewModel.isSearching && attempts < 10 {
            try? await Task.sleep(nanoseconds: 100_000_000)
            attempts += 1
        }
        
        #expect(viewModel.error != nil)
        #expect(viewModel.searchResults.isEmpty)
    }
    
    @Test("Clear resets all search state")
    func testClear() async {
        let mockRepository = MockCountriesRepository()
        let searchUseCase = SearchCountriesUseCase(repository: mockRepository)
        
        mockRepository.searchResults = [Country.mock(id: "EG", name: "Egypt")]
        
        let viewModel = await SearchViewModel(searchCountriesUseCase: searchUseCase)
        
        viewModel.searchQuery = "Egypt"
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        var attempts = 0
        while viewModel.isSearching && attempts < 10 {
            try? await Task.sleep(nanoseconds: 100_000_000)
            attempts += 1
        }
        
        viewModel.clear()
        
        #expect(viewModel.searchQuery.isEmpty)
        #expect(viewModel.searchResults.isEmpty)
        #expect(viewModel.hasSearched == false)
        #expect(viewModel.error == nil)
    }
}

