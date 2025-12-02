//
//  DependencyContainer.swift
//  Navigation
//
//  Created by Sherif Kamal on 02/12/2025.
//


import Foundation
import Networking
import Storage
import Location
import Core
import SwiftUI

public protocol DependencyContaining: AnyObject, Sendable {
    func resolve<T>() -> T
    func register<T>(_ dependency: T, for type: T.Type)
}

public final class DependencyContainer: ObservableObject, @unchecked Sendable {
    
    nonisolated(unsafe) public static let shared = DependencyContainer()
    
    private var dependencies: [String: Any] = [:]
    private let lock = NSLock()
    
    private init() {
        registerDefaults()
    }
    
    public func register<T>(_ dependency: T, for type: T.Type = T.self) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = String(describing: type)
        dependencies[key] = dependency
    }
    
    public func resolve<T>() -> T {
        lock.lock()
        defer { lock.unlock() }
        
        let key = String(describing: T.self)
        guard let dependency = dependencies[key] as? T else {
            fatalError("❌ Dependency '\(key)' not registered. Did you forget to register it?")
        }
        return dependency
    }
    
    public func isRegistered<T>(_ type: T.Type) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        
        let key = String(describing: type)
        return dependencies[key] != nil
    }
    
    private func registerDefaults() {
        let networkService = NetworkService()
        register(networkService, for: NetworkServiceProtocol.self)
        
        let storageService = StorageService()
        register(storageService, for: StorageServiceProtocol.self)
        
        let locationService = LocationService()
        register(locationService, for: LocationServiceProtocol.self)
    }
    
    /// Reset for testing clears all dependencies
    public func reset() {
        lock.lock()
        defer { lock.unlock() }
        dependencies.removeAll()
    }
    
    public static func makeForTesting() -> DependencyContainer {
        let container = DependencyContainer()
        container.reset()
        
        container.register(MockNetworkService(), for: NetworkServiceProtocol.self)
        container.register(MockStorageService(), for: StorageServiceProtocol.self)
        
        return container
    }
}

private struct ContainerKey: EnvironmentKey {
    static let defaultValue = DependencyContainer.shared
}

public extension EnvironmentValues {
    var container: DependencyContainer {
        get { self[ContainerKey.self] }
        set { self[ContainerKey.self] = newValue }
    }
}

