//
//  Coordinator.swift
//  Navigation
//
//  Created by Sherif Kamal on 02/12/2025.
//


public protocol Coordinator: ObservableObject {
    associatedtype Route: Hashable
    
    var path: NavigationPath { get set }
    
    func navigate(to route: Route)
    func pop()
    func popToRoot()
}

public extension Coordinator {
    func navigate(to route: Route) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
}

