//
//  Sheet.swift
//  Navigation
//
//  Created by Sherif Kamal on 02/12/2025.
//

import Foundation

public enum Sheet: Identifiable, Hashable, Sendable {
    case search
    case countryPicker
    
    public var id: String {
        switch self {
        case .search:
            return "search"
        case .countryPicker:
            return "countryPicker"
        }
    }
}

