//
//  MockStorageService.swift
//  CountriesListFeatureTests
//

import Foundation
import Core
import Storage

final class MockStorageService: StorageServiceProtocol, @unchecked Sendable {
    
    private let lock = NSLock()
    private var _savedCountries: [Country] = []
    private var _saveCountriesCallCount = 0
    private var _loadCountriesCallCount = 0
    private var _addCountryCallCount = 0
    private var _removeCountryCallCount = 0
    private var _clearAllCallCount = 0
    
    var maxCountries = 5
    
    var savedCountries: [Country] {
        lock.lock()
        defer { lock.unlock() }
        return _savedCountries
    }
    
    var saveCountriesCallCount: Int {
        lock.lock()
        defer { lock.unlock() }
        return _saveCountriesCallCount
    }
    
    var loadCountriesCallCount: Int {
        lock.lock()
        defer { lock.unlock() }
        return _loadCountriesCallCount
    }
    
    var addCountryCallCount: Int {
        lock.lock()
        defer { lock.unlock() }
        return _addCountryCallCount
    }
    
    var removeCountryCallCount: Int {
        lock.lock()
        defer { lock.unlock() }
        return _removeCountryCallCount
    }
    
    var clearAllCallCount: Int {
        lock.lock()
        defer { lock.unlock() }
        return _clearAllCallCount
    }
    
    func saveCountries(_ countries: [Country]) async {
        lock.lock()
        _saveCountriesCallCount += 1
        _savedCountries = Array(countries.prefix(maxCountries))
        lock.unlock()
    }
    
    func loadCountries() async -> [Country] {
        lock.lock()
        _loadCountriesCallCount += 1
        let countries = _savedCountries
        lock.unlock()
        return countries
    }
    
    func addCountry(_ country: Country) async -> Bool {
        lock.lock()
        _addCountryCallCount += 1
        
        if _savedCountries.contains(where: { $0.id == country.id }) {
            lock.unlock()
            return true
        }
        
        guard _savedCountries.count < maxCountries else {
            lock.unlock()
            return false
        }
        
        _savedCountries.append(country)
        lock.unlock()
        return true
    }
    
    func removeCountry(id: String) async {
        lock.lock()
        _removeCountryCallCount += 1
        _savedCountries.removeAll { $0.id == id }
        lock.unlock()
    }
    
    func clearAll() async {
        lock.lock()
        _clearAllCallCount += 1
        _savedCountries = []
        lock.unlock()
    }
    
    func reset() {
        lock.lock()
        _savedCountries = []
        _saveCountriesCallCount = 0
        _loadCountriesCallCount = 0
        _addCountryCallCount = 0
        _removeCountryCallCount = 0
        _clearAllCallCount = 0
        lock.unlock()
    }
}

