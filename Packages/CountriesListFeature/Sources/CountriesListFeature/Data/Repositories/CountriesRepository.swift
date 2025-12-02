//
//  CountriesRepository.swift
//  CountriesListFeature
//
//  Created by Sherif Kamal on 02/12/2025.
//


import Foundation
import Core
import Networking
import Storage

public final class CountriesRepository: CountriesRepositoryProtocol, @unchecked Sendable {
    
    private let networkService: NetworkServiceProtocol
    private let storageService: StorageServiceProtocol
    
    public init(
        networkService: NetworkServiceProtocol,
        storageService: StorageServiceProtocol
    ) {
        self.networkService = networkService
        self.storageService = storageService
    }
    
    public func fetchAllCountries() async throws -> [Country] {
        do {
            let dtos: [CountryDTO] = try await networkService.request(
                CountriesEndpoint.getAllCountries
            )
            
            let countries = dtos.map(CountryMapper.map)
            
            return countries.sorted { $0.name < $1.name }
            
        } catch {
            let cached = await storageService.loadCountries()
            if !cached.isEmpty {
                return cached
            }
            throw error
        }
    }
    
    public func searchCountries(by name: String) async throws -> [Country] {
        let dtos: [CountryDetailDTO] = try await networkService.request(
            CountriesEndpoint.searchByName(name)
        )
        
        return dtos.map(CountryMapper.mapDetail)
    }
    
    public func getCountryDetails(by code: String) async throws -> Country {
        let dto: CountryDetailDTO = try await networkService.request(
            CountriesEndpoint.searchByCode(code)
        )
        
        return CountryMapper.mapDetail(dto)
    }
    
    public func getCountryDetails(name: String) async throws -> CountryDetail {
        let dtos: [CountryDetailDTO] = try await networkService.request(
            CountriesEndpoint.searchByName(name)
        )
        
        guard let dto = dtos.first else {
            throw NetworkError.notFound
        }
        
        return CountryMapper.mapToDetail(dto)
    }
}

