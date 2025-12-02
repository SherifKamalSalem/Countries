//
//  SkeletonCountryCardView.swift
//  DesignSystem
//
//  Created by Sherif Kamal on 02/12/2025.
//

import SwiftUI

public struct SkeletonCountryCardView: View {
    
    public init() {}
    
    public var body: some View {
        HStack(spacing: AppSpacing.md) {
            RoundedRectangle(cornerRadius: AppCornerRadius.small)
                .fill(AppColors.divider)
                .frame(width: 60, height: 40)
            
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(AppColors.divider)
                    .frame(width: 120, height: 16)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(AppColors.divider)
                    .frame(width: 80, height: 12)
            }
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 4)
                .fill(AppColors.divider)
                .frame(width: 40, height: 14)
        }
        .padding(AppSpacing.md)
        .background(AppColors.backgroundCard)
        .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.medium))
        .shadow(color: AppColors.shadow, radius: 4, x: 0, y: 2)
        .shimmer()
    }
}

public struct SkeletonCountriesListView: View {
    
    private let itemCount: Int
    
    public init(itemCount: Int = 3) {
        self.itemCount = itemCount
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.sm) {
                ForEach(0..<itemCount, id: \.self) { _ in
                    SkeletonCountryCardView()
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.top, AppSpacing.xs)
        }
    }
}

#Preview {
    VStack {
        SkeletonCountryCardView()
            .padding()
        
        SkeletonCountriesListView()
    }
    .background(AppColors.background)
}

