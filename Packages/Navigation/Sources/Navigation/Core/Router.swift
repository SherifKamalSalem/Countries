//
//  Router.swift
//  Navigation
//
//  Created by Sherif Kamal on 02/12/2025.
//

import Foundation

public protocol Router: AnyObject, Sendable {
    @MainActor func navigate(to route: AppRoute)
    @MainActor func pop()
    @MainActor func popToRoot()
    @MainActor func present(sheet: Sheet)
    @MainActor func dismiss()
}

@MainActor
public final class AnyRouter: Router, @unchecked Sendable {
    
    private let _navigate: @MainActor (AppRoute) -> Void
    private let _pop: @MainActor () -> Void
    private let _popToRoot: @MainActor () -> Void
    private let _present: @MainActor (Sheet) -> Void
    private let _dismiss: @MainActor () -> Void
    
    public init<R: Router>(_ router: R) {
        _navigate = { route in router.navigate(to: route) }
        _pop = { router.pop() }
        _popToRoot = { router.popToRoot() }
        _present = { sheet in router.present(sheet: sheet) }
        _dismiss = { router.dismiss() }
    }
    
    public func navigate(to route: AppRoute) {
        _navigate(route)
    }
    
    public func pop() {
        _pop()
    }
    
    public func popToRoot() {
        _popToRoot()
    }
    
    public func present(sheet: Sheet) {
        _present(sheet)
    }
    
    public func dismiss() {
        _dismiss()
    }
}

