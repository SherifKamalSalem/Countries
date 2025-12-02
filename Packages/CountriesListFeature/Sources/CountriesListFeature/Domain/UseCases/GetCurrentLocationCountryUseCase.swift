//
//  GetCurrentLocationCountryUseCase.swift
//  CountriesListFeature
//
//  Created by Sherif Kamal on 02/12/2025.
//


import Foundation
import Core
import Location

public struct GetCurrentLocationCountryUseCase: Sendable {
    
    public enum Result: Sendable {
        case success(Country)
        case locationDenied
        case countryNotFound
        case error(Error)
    }
    
    private let locationService: LocationServiceProtocol
    private let repository: CountriesRepositoryProtocol
    private let defaultCountryName: String
    
    public init(
        locationService: LocationServiceProtocol,
        repository: CountriesRepositoryProtocol,
        defaultCountryName: String = "Egypt"
    ) {
        self.locationService = locationService
        self.repository = repository
        self.defaultCountryName = defaultCountryName
    }
    
    public func execute() async -> Result {
        do {
            let countryCode = try await locationService.getCurrentCountryCode()
            
            let country = try await repository.getCountryDetails(by: countryCode)
            
            return .success(country)
            
            return await fetchDefaultCountry()
            
        } catch {
            return await fetchDefaultCountry()
        }
    }
    
    private func fetchDefaultCountry() async -> Result {
        do {
            let countries = try await repository.searchCountries(by: defaultCountryName)
            if let country = countries.first {
                return .success(country)
            }
            return .countryNotFound
        } catch {
            return .error(error)
        }
    }
}

