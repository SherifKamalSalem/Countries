//
//  CountryCardView.swift
//  DesignSystem
//
//  Created by Sherif Kamal on 02/12/2025.
//


import SwiftUI

public struct CountryCardView: View {
    let name: String
    let capital: String?
    let currencyCode: String?
    let flagURL: URL?
    let onTap: () -> Void
    
    public init(
        name: String,
        capital: String?,
        currencyCode: String?,
        flagURL: URL?,
        onTap: @escaping () -> Void
    ) {
        self.name = name
        self.capital = capital
        self.currencyCode = currencyCode
        self.flagURL = flagURL
        self.onTap = onTap
    }
    
    public var body: some View {
        Button(action: onTap) {
            HStack(spacing: AppSpacing.md) {
                AsyncImage(url: flagURL) { phase in
                    switch phase {
                    case .empty:
                        RoundedRectangle(cornerRadius: AppCornerRadius.small)
                            .fill(AppColors.divider)
                            .overlay {
                                ProgressView()
                                    .tint(AppColors.primary)
                            }
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        RoundedRectangle(cornerRadius: AppCornerRadius.small)
                            .fill(AppColors.divider)
                            .overlay {
                                Image(systemName: "flag.fill")
                                    .foregroundStyle(AppColors.textTertiary)
                            }
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: AppSpacing.xxl, height: AppSpacing.xxl)
                .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.small))
                .shadow(color: AppColors.shadow, radius: 2, x: 0, y: 1)
                
                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    Text(name)
                        .font(AppTypography.headline)
                        .foregroundStyle(AppColors.textPrimary)
                        .lineLimit(1)
                    
                    if let capital = capital {
                        Label(capital, systemImage: "building.2")
                            .font(AppTypography.subheadline)
                            .foregroundStyle(AppColors.textSecondary)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                if let code = currencyCode {
                    Text(code)
                        .font(AppTypography.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(AppColors.primary)
                        .padding(.horizontal, AppSpacing.xs)
                        .padding(.vertical, AppSpacing.xxs)
                        .background(
                            Capsule()
                                .fill(AppColors.primary.opacity(0.1))
                        )
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(AppColors.textTertiary)
            }
            .padding(AppSpacing.md)
            .background(AppColors.backgroundCard)
            .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.medium))
            .shadow(color: AppColors.shadow, radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 12) {
        CountryCardView(
            name: "Egypt",
            capital: "Cairo",
            currencyCode: "EGP",
            flagURL: URL(string: "https://flagcdn.com/w320/eg.png"),
            onTap: {}
        )
        
        CountryCardView(
            name: "United States",
            capital: "Washington, D.C.",
            currencyCode: "USD",
            flagURL: nil,
            onTap: {}
        )
    }
    .padding()
    .background(AppColors.background)
}

