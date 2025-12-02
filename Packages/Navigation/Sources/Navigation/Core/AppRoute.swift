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
    case search
}
