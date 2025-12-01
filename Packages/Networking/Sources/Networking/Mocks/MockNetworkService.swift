//
//  MockNetworkService.swift
//  Networking
//
//  Created by Sherif Kamal on 02/12/2025.
//


import Foundation

public final class MockNetworkService: NetworkServiceProtocol, @unchecked Sendable {
    
    public var mockResponse: Any?
    public var mockError: Error?
    public var delay: TimeInterval = 0
    
    public init() {}
    
    public func request<T: Decodable & Sendable>(_ endpoint: Endpoint) async throws -> T {
        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        
        if let error = mockError {
            throw error
        }
        
        if let response = mockResponse as? T {
            return response
        }
        
        if let dtos = createMockCountries() as? T {
            return dtos
        }
        
        throw NetworkError.noData
    }
    
    private func createMockCountries() -> [CountryDTO] {
        [
            CountryDTO(
                name: "Egypt",
                capital: "Cairo",
                flags: CountryDTO.FlagsDTO(
                    svg: "https://flagcdn.com/eg.svg",
                    png: "https://flagcdn.com/w320/eg.png"
                ),
                currencies: [
                    CountryDTO.CurrencyDTO(code: "EGP", name: "Egyptian pound", symbol: "£")
                ]
            ),
            CountryDTO(
                name: "United States of America",
                capital: "Washington, D.C.",
                flags: CountryDTO.FlagsDTO(
                    svg: "https://flagcdn.com/us.svg",
                    png: "https://flagcdn.com/w320/us.png"
                ),
                currencies: [
                    CountryDTO.CurrencyDTO(code: "USD", name: "United States dollar", symbol: "$")
                ]
            ),
            CountryDTO(
                name: "Saudi Arabia",
                capital: "Riyadh",
                flags: CountryDTO.FlagsDTO(
                    svg: "https://flagcdn.com/sa.svg",
                    png: "https://flagcdn.com/w320/sa.png"
                ),
                currencies: [
                    CountryDTO.CurrencyDTO(code: "SAR", name: "Saudi riyal", symbol: "ر.س")
                ]
            )
        ]
    }
}

