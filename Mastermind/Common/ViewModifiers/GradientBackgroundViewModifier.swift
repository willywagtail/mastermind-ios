//
//  GradientBackgroundViewModifier.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 15/03/2026.
//

import SwiftUI

extension View {
    func gradientBackground(_ type: GradientBackgroundModifier.BackgroundType = .base) -> some View {
        modifier(GradientBackgroundModifier(type: type))
    }
    
}

// MARK: - View Modifier

struct GradientBackgroundModifier: ViewModifier {
    // MARK: - Properties
    
    let type: BackgroundType
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    colors: type.gradientColors,
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
    }
    
}

// MARK: - Background Type

extension GradientBackgroundModifier {
    enum BackgroundType {
        case base
        case success
        case failure
        
        private var baseColor: Color {
            switch self {
            case .base: .backgroundPrimary
            case .success: .backgroundSuccess
            case .failure: .backgroundFailure
            }
        }
        
        var gradientColors: [Color] {
            stride(from: 0.2, through: 1.0, by: 0.2).map { baseColor.opacity($0) }
        }
    }
    
}
