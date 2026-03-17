//
//  MastermindSuccessView.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 16/03/2026.
//

import SwiftUI

struct MastermindResultView: View {
    // MARK: - Properties
    
    let didTapPlayAgain: () -> Void
    let result: ResultType
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Spacer()
                .frame(height: 40)
            
            Text(result.title)
                .foregroundStyle(.foreground)
                .font(.system(size: 72, weight: .bold))
                .multilineTextAlignment(.center)
                
            Text(result.emoji)
                .font(.system(size: 72))
            
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
