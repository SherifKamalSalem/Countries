//
//  ErrorView.swift
//  DesignSystem
//
//  Created by Sherif Kamal on 02/12/2025.
//


import SwiftUI

public struct ErrorView: View {
    let title: String
    let message: String
    let retryAction: (() -> Void)?
    
    public init(
        title: String = "Something went wrong",
        message: String,
        retryAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.retryAction = retryAction
    }
    
    public var body: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: AppSpacing.xxl))
                .foregroundStyle(AppColors.error)
            
            VStack(spacing: AppSpacing.xs) {
                Text(title)
                    .font(AppTypography.headline)
                    .foregroundStyle(AppColors.textPrimary)
                
                Text(message)
                    .font(AppTypography.subheadline)
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            if let retryAction {
                Button(action: retryAction) {
                    Label("Try Again", systemImage: "arrow.clockwise")
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
    ErrorView(
        message: "Unable to load countries. Please check your internet connection.",
        retryAction: {}
    )
}

