//
//  CountriesApp.swift
//  Countries
//
//  Created by Sherif Kamal on 01/12/2025.
//

import SwiftUI
import CountriesListFeature
import Navigation

@main
struct CountriesApp: App {
    
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            CountriesListRootView(appCoordinator: coordinator)
                .environment(\.container, .shared)
        }
    }
}
