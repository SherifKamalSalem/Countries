//
//  ShimmerModifier.swift
//  DesignSystem
//
//  Created by Sherif Kamal on 02/12/2025.
//

import SwiftUI

public struct ShimmerModifier: ViewModifier {
    
    @State private var phase: CGFloat = 0
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.clear,
                            Color.white.opacity(0.4),
                            Color.clear
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 2)
                    .offset(x: -geometry.size.width + (phase * geometry.size.width * 2))
                }
            )
            .mask(content)
            .onAppear {
                withAnimation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 1
                }
            }
    }
}

public extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}

