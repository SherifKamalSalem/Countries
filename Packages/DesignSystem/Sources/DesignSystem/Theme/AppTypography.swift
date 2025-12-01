//
//  AppTypography.swift
//  DesignSystem
//
//  Created by Sherif Kamal on 01/12/2025.
//

import SwiftUI

public enum AppTypography {
    public static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
    public static let title = Font.system(size: 28, weight: .bold, design: .rounded)
    public static let title2 = Font.system(size: 22, weight: .semibold, design: .rounded)
    public static let title3 = Font.system(size: 20, weight: .semibold, design: .default)
    
    public static let headline = Font.system(size: 17, weight: .semibold, design: .default)
    public static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
    
    public static let body = Font.system(size: 17, weight: .regular, design: .default)
    public static let bodyMedium = Font.system(size: 17, weight: .medium, design: .default)
    
    public static let callout = Font.system(size: 16, weight: .regular, design: .default)
    public static let caption = Font.system(size: 12, weight: .regular, design: .default)
    public static let caption2 = Font.system(size: 11, weight: .regular, design: .default)
    
    public static let footnote = Font.system(size: 13, weight: .regular, design: .default)
}

public extension View {
    func titleStyle() -> some View {
        self
            .font(AppTypography.title)
            .foregroundStyle(AppColors.textPrimary)
    }
    
    func headlineStyle() -> some View {
        self
            .font(AppTypography.headline)
            .foregroundStyle(AppColors.textPrimary)
    }
    
    func bodyStyle() -> some View {
        self
            .font(AppTypography.body)
            .foregroundStyle(AppColors.textPrimary)
    }
    
    func captionStyle() -> some View {
        self
            .font(AppTypography.caption)
            .foregroundStyle(AppColors.textSecondary)
    }
}
