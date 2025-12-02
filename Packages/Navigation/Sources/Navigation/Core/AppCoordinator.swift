//
//  AppCoordinator.swift
//  Navigation
//
//  Created by Sherif Kamal on 02/12/2025.
//

import Core
import SwiftUI

@MainActor
public final class AppCoordinator: ObservableObject, Router {
    
    @Published public var path = NavigationPath()
    
    @Published public var presentedSheet: Sheet?
    
    @Published public var fullScreenCover: Sheet?
    
    public init() {}
    
    public func navigate(to route: AppRoute) {
        switch route {
        case .countriesList:
            popToRoot()
        case .countryDetail:
            path.append(route)
        }
    }
    
    public func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    public func popToRoot() {
        path = NavigationPath()
    }
    
    public func present(sheet: Sheet) {
        presentedSheet = sheet
    }
    
    public func dismiss() {
        if presentedSheet != nil {
            presentedSheet = nil
        } else if fullScreenCover != nil {
            fullScreenCover = nil
        }
    }
    
    public func presentFullScreen(_ sheet: Sheet) {
        fullScreenCover = sheet
    }
    public func isPresenting(_ sheet: Sheet) -> Bool {
        presentedSheet == sheet || fullScreenCover == sheet
    }
    
    public func asRouter() -> AnyRouter {
        AnyRouter(self)
    }
}

