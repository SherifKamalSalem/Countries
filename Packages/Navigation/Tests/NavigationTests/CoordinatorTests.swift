//
//  CoordinatorTests.swift
//  Navigation
//
//  Created by Sherif Kamal on 02/12/2025.
//


import Testing
import Core
import Navigation

@MainActor
struct CoordinatorTests {
    
    @Test("Coordinator starts with empty path")
    func testInitialState() {
        let coordinator = AppCoordinator()
        
        #expect(coordinator.path.isEmpty)
        #expect(coordinator.showSearch == false)
    }
    
    @Test("Navigate to detail adds to path")
    func testNavigateToDetail() {
        let coordinator = AppCoordinator()
        let country = Country.mock()
        
        coordinator.navigate(to: .countryDetail(country))
        
        #expect(coordinator.path.count == 1)
    }
    
    @Test("Pop to root clears path")
    func testPopToRoot() {
        let coordinator = AppCoordinator()
        let country = Country.mock()
        
        coordinator.navigate(to: .countryDetail(country))
        coordinator.popToRoot()
        
        #expect(coordinator.path.isEmpty)
    }
    
    @Test("Navigate to search shows modal")
    func testSearchModal() {
        let coordinator = AppCoordinator()
        
        coordinator.navigate(to: .search)
        
        #expect(coordinator.showSearch == true)
    }
    
    @Test("Dismiss search hides modal")
    func testDismissSearch() {
        let coordinator = AppCoordinator()
        
        coordinator.navigate(to: .search)
        coordinator.dismissSearch()
        
        #expect(coordinator.showSearch == false)
    }
}

