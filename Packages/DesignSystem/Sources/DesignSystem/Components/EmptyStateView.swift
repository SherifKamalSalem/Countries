//
//  EmptyStateView.swift
//  DesignSystem
//
//  Created by Sherif Kamal on 02/12/2025.
//


import SwiftUI

public struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    public init(
        icon: String,
        title: String,
        subtitle: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.actionTitle = actionTitle
        self.action = action
    }
    
    public var body: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 56))
                .foregroundStyle(AppColors.primary.opacity(0.6))
            
            VStack(spacing: AppSpacing.xs) {
                Text(title)
                    .font(AppTypography.title3)
                    .foregroundStyle(AppColors.textPrimary)
                
                Text(subtitle)
                    .font(AppTypography.subheadline)
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            if let actionTitle, let action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(AppTypography.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.vertical, AppSpacing.sm)
                        .background(AppColors.primary)
                        .clipShape(Capsule())
                }
                .padding(.top, AppSpacing.xs)
            }
        }
        .padding(AppSpacing.xl)
    }
}

#Preview {
    EmptyStateView(
        icon: "globe.europe.africa",
        title: "No Countries Yet",
        subtitle: "Search for countries to add them to your list",
        actionTitle: "Start Exploring",
        action: {}
    )
}

