//
//  NetworkServiceTests.swift
//  Networking
//
//  Created by Sherif Kamal on 02/12/2025.
//


import Testing
@testable import NetworkingKit

struct NetworkServiceTests {
    
    @Test("Endpoint should have correct base URL")
    func testBaseURL() {
        let endpoint = CountriesEndpoint.getAllCountries
        #expect(endpoint.baseURL == "https://restcountries.com")
    }
    
    @Test("Search endpoint encodes name in path")
    func testSearchPath() {
        let endpoint = CountriesEndpoint.searchByName("Egypt")
        #expect(endpoint.path == "/v2/name/Egypt")
    }
    
    @Test("Get all countries has fields query param")
    func testQueryParams() {
        let endpoint = CountriesEndpoint.getAllCountries
        #expect(endpoint.queryParameters["fields"] != nil)
    }
    
    @Test("Mock service returns data")
    func testMockService() async throws {
        let mockService = MockNetworkService()
        let endpoint = CountriesEndpoint.getAllCountries
        
        let countries: [CountryDTO] = try await mockService.request(endpoint)
        
        #expect(countries.count == 3)
        #expect(countries.first?.name == "Egypt")
    }
    
    @Test("Mock service can throw error")
    func testMockServiceError() async {
        let mockService = MockNetworkService()
        mockService.mockError = NetworkError.offline
        
        do {
            let _: [CountryDTO] = try await mockService.request(CountriesEndpoint.getAllCountries)
            #expect(Bool(false), "Should have thrown")
        } catch {
            #expect(error is NetworkError)
        }
    }
}

