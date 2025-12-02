//
//  CountriesError.swift
//  CountriesListFeature
//
//  Created by Sherif Kamal on 02/12/2025.
//


enum CountriesError: LocalizedError {
    case limitReached
    
    var errorDescription: String? {
        switch self {
        case .limitReached:
            return "You can only save up to 5 countries."
        }
    }
}
