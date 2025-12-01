//
//  CountriesApp.swift
//  Countries
//
//  Created by Sherif Kamal on 01/12/2025.
//

import SwiftUI
import CoreData

@main
struct CountriesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
