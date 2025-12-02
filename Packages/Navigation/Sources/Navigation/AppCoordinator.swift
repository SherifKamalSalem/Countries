//
//  AppCoordinator.swift
//  Navigation
//
//  Created by Sherif Kamal on 02/12/2025.
//

import Core

@MainActor
public final class AppCoordinator: ObservableObject {
    
    @Published public var path = NavigationPath()
    @Published public var showSearch = false
    
    public init() {}
    
    public func navigate(to route: AppRoute) {
        switch route {
        case .countriesList:
            popToRoot()
        case .countryDetail(let country):
            path.append(route)
        case .search:
            showSearch = true
        }
    }
    
    public func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    public func popToRoot() {
        path = NavigationPath()
    }
    
    public func dismissSearch() {
        showSearch = false
    }
}

