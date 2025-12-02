//
//  LoadingView.swift
//  DesignSystem
//
//  Created by Sherif Kamal on 02/12/2025.
//


import SwiftUI

public struct LoadingView: View {
    let message: String
    
    public init(message: String = "Loading...") {
        self.message = message
    }
    
    public var body: some View {
        VStack(spacing: AppSpacing.md) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: AppColors.primary))
                .scaleEffect(1.2)
            
            Text(message)
                .font(AppTypography.subheadline)
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

public struct LoadingOverlay: ViewModifier {
    let isLoading: Bool
    
    public func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading)
            
            if isLoading {
                Color.black.opacity(0.2)
                    .ignoresSafeArea()
                
                LoadingView()
                    .padding()
                    .background(AppColors.backgroundCard)
                    .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.medium))
                    .shadow(color: AppColors.shadow, radius: 10)
            }
        }
    }
}

public extension View {
    func loadingOverlay(_ isLoading: Bool) -> some View {
        modifier(LoadingOverlay(isLoading: isLoading))
    }
}

#Preview {
    LoadingView()
}

