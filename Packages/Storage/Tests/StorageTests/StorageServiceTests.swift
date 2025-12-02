//
//  StorageServiceTests.swift
//  Storage
//
//  Created by Sherif Kamal on 02/12/2025.
//


import Testing
@testable import Storage
import Core

struct StorageServiceTests {
    
    @Test("Can save and load countries")
    func testSaveLoad() async {
        let storage = MockStorageService()
        let country = Country.mock()
        
        await storage.saveCountries([country])
        let loaded = await storage.loadCountries()
        
        #expect(loaded.count == 1)
        #expect(loaded.first?.name == "Egypt")
    }
    
    @Test("Cannot add more than 5 countries")
    func testLimit() async {
        let storage = MockStorageService()
        
        for i in 0..<5 {
            let country = Country.mock(id: "C\(i)", name: "Country \(i)")
            let added = await storage.addCountry(country)
            #expect(added == true)
        }
        
        let extra = Country.mock(id: "C5", name: "Country 5")
        let added = await storage.addCountry(extra)
        #expect(added == false)
    }
    
    @Test("Can remove country")
    func testRemove() async {
        let storage = MockStorageService()
        let country = Country.mock()
        
        _ = await storage.addCountry(country)
        await storage.removeCountry(id: country.id)
        
        let loaded = await storage.loadCountries()
        #expect(loaded.isEmpty)
    }
    
    @Test("Clear removes all")
    func testClear() async {
        let storage = MockStorageService()
        _ = await storage.addCountry(Country.mock())
        
        await storage.clearAll()
        
        let loaded = await storage.loadCountries()
        #expect(loaded.isEmpty)
    }
        
    @Test("FileManager storage can save and load")
    func testFileManagerSaveLoad() async throws {
        let tempDir = FileManager.default.temporaryDirectory
        let testDir = tempDir.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: testDir, withIntermediateDirectories: true)
        
        defer {
            try? FileManager.default.removeItem(at: testDir)
        }
        
        let storage = StorageService(storageDirectory: testDir)
        
        let country = Country.mock()
        await storage.saveCountries([country])
        
        let loaded = await storage.loadCountries()
        
        #expect(loaded.count == 1)
        #expect(loaded.first?.name == "Egypt")
    }
    
    @Test("FileManager storage handles empty file gracefully")
    func testFileManagerEmptyFile() async throws {
        let tempDir = FileManager.default.temporaryDirectory
        let testDir = tempDir.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: testDir, withIntermediateDirectories: true)
        
        defer {
            try? FileManager.default.removeItem(at: testDir)
        }
        
        let storage = StorageService(storageDirectory: testDir)
        
        let loaded = await storage.loadCountries()
        
        #expect(loaded.isEmpty)
    }
    
    @Test("FileManager storage enforces limit")
    func testFileManagerLimit() async throws {
        let tempDir = FileManager.default.temporaryDirectory
        let testDir = tempDir.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: testDir, withIntermediateDirectories: true)
        
        defer {
            try? FileManager.default.removeItem(at: testDir)
        }
        
        let storage = StorageService(storageDirectory: testDir)
        
        for i in 0..<5 {
            let country = Country.mock(id: "C\(i)", name: "Country \(i)")
            let added = await storage.addCountry(country)
            #expect(added == true)
        }
        
        let extra = Country.mock(id: "C5", name: "Country 5")
        let added = await storage.addCountry(extra)
        #expect(added == false)
        
        let loaded = await storage.loadCountries()
        #expect(loaded.count == 5)
    }
}

