//
//  SearchBarView.swift
//  DesignSystem
//
//  Created by Sherif Kamal on 02/12/2025.
//


import SwiftUI

public struct SearchBarView: View {
    @Binding var text: String
    let placeholder: String
    let onSubmit: (() -> Void)?
    
    @FocusState private var isFocused: Bool
    
    public init(
        text: Binding<String>,
        placeholder: String = "Search countries...",
        onSubmit: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.onSubmit = onSubmit
    }
    
    public var body: some View {
        HStack(spacing: AppSpacing.xs) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(isFocused ? AppColors.primary : AppColors.textTertiary)
            
            TextField(placeholder, text: $text)
                .font(AppTypography.body)
                .focused($isFocused)
                .submitLabel(.search)
                .onSubmit {
                    onSubmit?()
                }
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(AppColors.textTertiary)
                }
            }
        }
        .padding(.horizontal, AppSpacing.sm)
        .padding(.vertical, AppSpacing.xs + 2)
        .background(AppColors.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.medium))
        .overlay {
            RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                .stroke(isFocused ? AppColors.primary : AppColors.divider, lineWidth: 1)
        }
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

#Preview {
    VStack {
        SearchBarView(text: .constant(""))
        SearchBarView(text: .constant("Egypt"))
    }
    .padding()
    .background(AppColors.background)
}

