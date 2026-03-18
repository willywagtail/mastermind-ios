//
//  MastermindResultView.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 16/03/2026.
//

import SwiftUI

struct MastermindResultView: View {
    // MARK: - Properties
    
    let didTapPlayAgain: () -> Void
    let result: ResultType
    
    // MARK: - State
    
    @AccessibilityFocusState private var isTitleFocused: Bool
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            Spacer()
                .frame(height: 32)
            
            Text(result.title)
                .foregroundStyle(.foregroundPrimary)
                .font(.system(size: 52, weight: .bold))
                .multilineTextAlignment(.center)
                .accessibilitySortPriority(1)
                .accessibilityFocused($isTitleFocused)
                
            Text(result.emoji)
                .font(.system(size: 72))
                .accessibilityHidden(true)
            
            CharacterInputView(displayStates: result.neutralResultStates,
                               readOnly: true)
            
            Spacer()
            
            Button(.successPlayAgainButton) {
                didTapPlayAgain()
            }
            .customButtonStyle(.outline)
            
        }
        .padding([.vertical, .horizontal])
        .gradientBackground(result.backgroundGradientType)
        .task { isTitleFocused = true }
    }
    
}

extension MastermindResultView {
    enum ResultType {
        case success(ValidationResult)
        case failure(ValidationResult)
        
        var title: LocalizedStringResource {
            switch self {
            case .success: .successTitleLabel
            case .failure: .failureTitleLabel
            }
        }
        
        var backgroundGradientType: GradientBackgroundModifier.BackgroundType {
            switch self {
            case .success: .success
            case .failure: .failure
            }
        }
        
        var emoji: String {
            switch self {
            case .success: "🎉"
            case .failure: "😭"
            }
        }
        
        var neutralResultStates: [CharacterState] {
            switch self {
            case .success(let validationResult), .failure(let validationResult): validationResult.neutralResult
            }
        }
    }
    
}
