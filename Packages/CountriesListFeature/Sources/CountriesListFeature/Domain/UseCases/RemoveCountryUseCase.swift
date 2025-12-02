//
//  RemoveCountryUseCase.swift
//  CountriesListFeature
//
//  Created by Sherif Kamal on 02/12/2025.
//


import Foundation
import Core
import Storage

public struct RemoveCountryUseCase: Sendable {
    
    private let storageService: StorageServiceProtocol
    
    public init(storageService: StorageServiceProtocol) {
        self.storageService = storageService
    }
    
    public func execute(countryId: String) async {
        await storageService.removeCountry(id: countryId)
    }
}

