//
//  AppRoute.swift
//  Navigation
//
//  Created by Sherif Kamal on 02/12/2025.
//

import Foundation
import Core

public enum AppRoute: Hashable, Sendable {
    case countriesList
    case countryDetail(Country)
}

public extension AppRoute {
    
    var title: String {
        switch self {
        case .countriesList:
            return "Countries List"
        case .countryDetail(let country):
            return country.name
        }
    }
}
