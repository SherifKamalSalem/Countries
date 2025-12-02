//
//  SearchCountriesUseCaseTests.swift
//  CountriesListFeatureTests
//

import Testing
@testable import CountriesListFeature
import Core

struct SearchCountriesUseCaseTests {
    
    @Test("Return empty array when query is too short")
    func testSearchQueryTooShort() async throws {
        let mockRepository = MockCountriesRepository()
        let useCase = SearchCountriesUseCase(repository: mockRepository)
        
        let results = try await useCase.execute(query: "A")
        
        #expect(results.isEmpty)
        #expect(mockRepository.searchCallCount == 0)
    }
    
    @Test("Return empty array when query is single character")
    func testSearchSingleCharacter() async throws {
        let mockRepository = MockCountriesRepository()
        let useCase = SearchCountriesUseCase(repository: mockRepository)
        
        let results = try await useCase.execute(query: "E")
        
        #expect(results.isEmpty)
        #expect(mockRepository.searchCallCount == 0)
    }
    
    @Test("Search with valid query returns results")
    func testSearchWithValidQuery() async throws {
        let mockRepository = MockCountriesRepository()
        let useCase = SearchCountriesUseCase(repository: mockRepository)
        
        let expectedCountries = [
            Country.mock(id: "EG", name: "Egypt"),
            Country.mock(id: "ET", name: "Ethiopia")
        ]
        mockRepository.searchResults = expectedCountries
        
        let results = try await useCase.execute(query: "Eg")
        
        #expect(results.count == 2)
        #expect(mockRepository.searchCallCount == 1)
    }
    
    @Test("Search with minimum length query works")
    func testSearchWithMinimumLength() async throws {
        let mockRepository = MockCountriesRepository()
        let useCase = SearchCountriesUseCase(repository: mockRepository)
        
        mockRepository.searchResults = [Country.mock(id: "US", name: "United States")]
        
        let results = try await useCase.execute(query: "US")
        
        #expect(results.count == 1)
        #expect(mockRepository.searchCallCount == 1)
    }
    
    @Test("Search propagates repository errors")
    func testSearchPropagatesError() async throws {
        let mockRepository = MockCountriesRepository()
        let useCase = SearchCountriesUseCase(repository: mockRepository)
        
        let testError = NSError(domain: "TestError", code: 500)
        mockRepository.searchError = testError
        
        await #expect(throws: NSError.self) {
            try await useCase.execute(query: "Egypt")
        }
    }
    
    @Test("Search with long query returns results")
    func testSearchWithLongQuery() async throws {
        let mockRepository = MockCountriesRepository()
        let useCase = SearchCountriesUseCase(repository: mockRepository)
        
        mockRepository.searchResults = [Country.mock(id: "US", name: "United States")]
        
        let results = try await useCase.execute(query: "United States of America")
        
        #expect(results.count == 1)
        #expect(mockRepository.searchCallCount == 1)
    }
}

