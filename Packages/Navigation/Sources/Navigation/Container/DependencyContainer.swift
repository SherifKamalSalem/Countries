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
    func resolveOptional<T>() -> T?
    func register<T>(_ dependency: T, for type: T.Type)
}

public final class DependencyContainer: ObservableObject, DependencyContaining, @unchecked Sendable {
    
    public static let shared = DependencyContainer()
    
    private var dependencies: [String: Any] = [:]
    private var factories: [String: () -> Any] = [:]
    private let lock = NSLock()
    
    private init() {
        registerCoreServices()
    }
    
    public func register<T>(_ dependency: T, for type: T.Type = T.self) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = String(describing: type)
        dependencies[key] = dependency
    }
    
    public func registerFactory<T>(_ factory: @escaping () -> T, for type: T.Type = T.self) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = String(describing: type)
        factories[key] = factory
    }
    
    public func resolve<T>() -> T {
        lock.lock()
        defer { lock.unlock() }
        
        let key = String(describing: T.self)
        
        if let dependency = dependencies[key] as? T {
            return dependency
        }
        
        if let factory = factories[key], let instance = factory() as? T {
            return instance
        }
        
        fatalError("❌ Dependency '\(key)' not registered. Did you forget to register it?")
    }
    
    public func resolveOptional<T>() -> T? {
        lock.lock()
        defer { lock.unlock() }
        
        let key = String(describing: T.self)
        
        if let dependency = dependencies[key] as? T {
            return dependency
        }
        
        if let factory = factories[key], let instance = factory() as? T {
            return instance
        }
        
        return nil
    }
    
    public func isRegistered<T>(_ type: T.Type) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        
        let key = String(describing: type)
        return dependencies[key] != nil || factories[key] != nil
    }
    
    private func registerCoreServices() {
        let networkService = NetworkService()
        register(networkService, for: NetworkServiceProtocol.self)
        
        let storageService = StorageService()
        register(storageService, for: StorageServiceProtocol.self)
        
        let locationService = LocationService()
        register(locationService, for: LocationServiceProtocol.self)
    }
    
    public func reset() {
        lock.lock()
        defer { lock.unlock() }
        dependencies.removeAll()
        factories.removeAll()
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

private struct RouterKey: EnvironmentKey {
    static let defaultValue: Router? = nil
}

public extension EnvironmentValues {
    var container: DependencyContainer {
        get { self[ContainerKey.self] }
        set { self[ContainerKey.self] = newValue }
    }
    
    var router: Router? {
        get { self[RouterKey.self] }
        set { self[RouterKey.self] = newValue }
    }
}

