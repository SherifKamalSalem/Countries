//
//  CountryDetailView.swift
//  CountryDetailsFeature
//

import SwiftUI
import Core
import DesignSystem

public struct CountryDetailView: View {
    
    @State private var viewModel: CountryDetailViewModel
    
    public init(viewModel: CountryDetailViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                flagHeader
                
                detailsSection
            }
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationTitle(viewModel.country.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var flagHeader: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
                if let flagURL = viewModel.country.flagURL {
                    AsyncImage(url: flagURL) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .fill(AppColors.divider)
                                .overlay {
                                    ProgressView()
                                        .tint(AppColors.primary)
                                }
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: 280)
                                .clipped()
                        case .failure:
                            Rectangle()
                                .fill(AppColors.divider)
                                .overlay {
                                    Image(systemName: "flag.fill")
                                        .font(.system(size: 60))
                                        .foregroundStyle(AppColors.textTertiary)
                                }
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: geometry.size.width, height: 280)
                } else {
                    Rectangle()
                        .fill(AppColors.divider)
                        .frame(width: geometry.size.width, height: 280)
                        .overlay {
                            Image(systemName: "flag.fill")
                                .font(.system(size: 60))
                                .foregroundStyle(AppColors.textTertiary)
                        }
                }
                
                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    Text(viewModel.country.name)
                        .font(AppTypography.title)
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                }
                .padding(AppSpacing.lg)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(height: 280)
    }
    
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.lg) {
            capitalRow
            currencyRow
        }
        .padding(AppSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var capitalRow: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Label("Capital City", systemImage: "building.2.fill")
                .font(AppTypography.headline)
                .foregroundStyle(AppColors.textSecondary)
            
            Text(viewModel.formattedCapital)
                .font(AppTypography.title2)
                .foregroundStyle(AppColors.textPrimary)
        }
        .padding(AppSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColors.backgroundCard)
        .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.medium))
        .shadow(color: AppColors.shadow, radius: 2, x: 0, y: 1)
    }
    
    private var currencyRow: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Label("Currency", systemImage: "dollarsign.circle.fill")
                .font(AppTypography.headline)
                .foregroundStyle(AppColors.textSecondary)
            
            Text(viewModel.formattedCurrencies)
                .font(AppTypography.title2)
                .foregroundStyle(AppColors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(AppSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColors.backgroundCard)
        .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.medium))
        .shadow(color: AppColors.shadow, radius: 2, x: 0, y: 1)
    }
}
