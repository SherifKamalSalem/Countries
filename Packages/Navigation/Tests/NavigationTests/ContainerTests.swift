//
//  ContainerTests.swift
//  Navigation
//
//  Created by Sherif Kamal on 02/12/2025.
//


//
//  ContainerTests.swift
//  Navigation
//
//  Created by Sherif Kamal on 02/12/2025.
//


import Testing
@testable import Navigation
import Networking
import Storage
import Location

@MainActor
struct ContainerTests {
    
    @Test("Container resolves registered dependencies")
    func testResolve() {
        let container = DependencyContainer.makeForTesting()
        
        let network: NetworkServiceProtocol = container.resolve()
        
        #expect(network is MockNetworkService)
    }
    
    @Test("Container can check if dependency exists")
    func testIsRegistered() {
        let container = DependencyContainer.makeForTesting()
        
        #expect(container.isRegistered(NetworkServiceProtocol.self))
    }
    
    @Test("Test container has mock services")
    func testMocks() {
        let container = DependencyContainer.makeForTesting()
        
        let storage: StorageServiceProtocol = container.resolve()
        
        #expect(storage is MockStorageService)
    }
}

