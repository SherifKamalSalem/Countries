//
//  NavigationAction.swift
//  Navigation
//
//  Created by Sherif Kamal on 02/12/2025.
//

import Foundation

public enum NavigationAction: Equatable, Sendable {
    case push
    case pop
    case popToRoot
    case present
    case dismiss
}

