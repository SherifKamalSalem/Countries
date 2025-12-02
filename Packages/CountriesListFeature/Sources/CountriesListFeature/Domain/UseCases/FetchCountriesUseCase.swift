//
//  FetchCountriesUseCase.swift
//  CountriesListFeature
//
//  Created by Sherif Kamal on 02/12/2025.
//

import Foundation
import Core

public struct FetchCountriesUseCase: Sendable {
    
    private let repository: CountriesRepositoryProtocol
    
    public init(repository: CountriesRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute() async throws -> [Country] {
        try await repository.fetchAllCountries()
    }
}

