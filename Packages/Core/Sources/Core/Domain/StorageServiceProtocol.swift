//
//  StorageServiceProtocol.swift
//  Core
//

import Foundation

public protocol StorageServiceProtocol: Sendable {
    func saveCountries(_ countries: [Country]) async
    func loadCountries() async -> [Country]
    func addCountry(_ country: Country) async -> Bool
    func removeCountry(id: String) async
    func clearAll() async
}

