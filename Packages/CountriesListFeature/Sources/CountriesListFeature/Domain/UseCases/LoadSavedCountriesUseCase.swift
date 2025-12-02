//
//  LoadSavedCountriesUseCase.swift
//  CountriesListFeature
//
//  Created by Sherif Kamal on 02/12/2025.
//


import Foundation
import Core
import Storage

public struct LoadSavedCountriesUseCase: Sendable {
    
    private let storageService: StorageServiceProtocol
    
    public init(storageService: StorageServiceProtocol) {
        self.storageService = storageService
    }
    
    public func execute() async -> [Country] {
        await storageService.loadCountries()
    }
}

