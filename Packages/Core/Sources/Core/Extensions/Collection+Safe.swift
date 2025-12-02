//
//  Collection+Safe.swift
//  Core
//
//  Created by Sherif Kamal on 02/12/2025.
//


import Foundation

public extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

