//
//  StorageService.swift
//  Storage
//
//  Created by Sherif Kamal on 02/12/2025.
//


import Foundation
import Core

public final class StorageService: StorageServiceProtocol, @unchecked Sendable {
    
    private let fileManager: FileManager
    private let storageURL: URL
    private let maxCountries = 5
    
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    public init(
        fileManager: FileManager = .default,
        storageDirectory: URL? = nil
    ) {
        self.fileManager = fileManager
        
        if let directory = storageDirectory {
            self.storageURL = directory.appendingPathComponent("saved_countries.json")
        } else {
            let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            self.storageURL = documentsPath.appendingPathComponent("saved_countries.json")
        }
        
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
        
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    }
    
    public func saveCountries(_ countries: [Country]) async {
        let limitedCountries = Array(countries.prefix(maxCountries))
        
        do {
            let data = try encoder.encode(limitedCountries)
            
            let tempURL = storageURL.appendingPathExtension("tmp")
            
            try data.write(to: tempURL, options: [.atomic])
            try fileManager.replaceItem(at: storageURL, withItemAt: tempURL, backupItemName: nil, options: [], resultingItemURL: nil)
            
        } catch {
            #if DEBUG
            debugPrint("Failed to save countries: \(error)")
            #endif
        }
    }
    
    public func loadCountries() async -> [Country] {
        guard fileManager.fileExists(atPath: storageURL.path) else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: storageURL)
            return try decoder.decode([Country].self, from: data)
        } catch {
            #if DEBUG
            debugPrint("Failed to load countries: \(error)")
            #endif
            return []
        }
    }
    
    public func addCountry(_ country: Country) async -> Bool {
        var countries = await loadCountries()
        
        if countries.contains(where: { $0.id == country.id }) {
            return true
        }
        
        guard countries.count < maxCountries else {
            return false
        }
        
        countries.append(country)
        await saveCountries(countries)
        return true
    }
    
    public func removeCountry(id: String) async {
        var countries = await loadCountries()
        countries.removeAll { $0.id == id }
        await saveCountries(countries)
    }
    
    public func clearAll() async {
        guard fileManager.fileExists(atPath: storageURL.path) else {
            return
        }
        
        do {
            try fileManager.removeItem(at: storageURL)
        } catch {
            #if DEBUG
            debugPrint("Failed to clear countries: \(error)")
            #endif
        }
    }
}
