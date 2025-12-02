//
//  CountriesError.swift
//  Core
//

import Foundation

public enum CountriesError: LocalizedError, Sendable {
    case limitReached
    
    public var errorDescription: String? {
        switch self {
        case .limitReached:
            return "You can only save up to 5 countries."
        }
    }
}

