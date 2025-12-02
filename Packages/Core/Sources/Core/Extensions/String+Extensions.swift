//
//  String+Extensions.swift
//  Core
//
//  Created by Sherif Kamal on 02/12/2025.
//


import Foundation

public extension String {
    var isNotEmpty: Bool {
        !isEmpty
    }
    
    func trimmed() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

