//
//  SearchCountriesUseCase.swift
//  CountriesListFeature
//
//  Created by Sherif Kamal on 02/12/2025.
//


import Foundation
import Core

public struct SearchCountriesUseCase: Sendable {
    
    private let repository: CountriesRepositoryProtocol
    
    public init(repository: CountriesRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(query: String) async throws -> [Country] {
        guard query.count >= 2 else {
            return []
        }
        
        return try await repository.searchCountries(by: query)
    }
}

