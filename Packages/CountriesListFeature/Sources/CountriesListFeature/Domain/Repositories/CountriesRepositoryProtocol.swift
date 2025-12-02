//
//  CountriesRepositoryProtocol.swift
//  CountriesListFeature
//
//  Created by Sherif Kamal on 02/12/2025.
//


import Foundation
import Core

public protocol CountriesRepositoryProtocol: Sendable {
    func fetchAllCountries() async throws -> [Country]
    func searchCountries(by name: String) async throws -> [Country]
    func getCountryDetails(by code: String) async throws -> Country
    func getCountryDetails(name: String) async throws -> CountryDetail
}

