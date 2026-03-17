//
//  MastermindSuccessView.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 16/03/2026.
//

import SwiftUI

struct MastermindSuccessView: View {
    // MARK: - Properties
    
    let didTapPlayAgain: () -> Void
    let solution: ValidationResult
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Spacer()
                .frame(height: 72)
            
            Text(.successYouWonLabel)
                .foregroundStyle(.foreground)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            
            Text("🎉")
                .font(.system(size: 72))
            
            CharacterInputView(displayStates: solution.states,
                               readOnly: true)
            
            Spacer()
            
            Button(.successPlayAgainButton) {
                didTapPlayAgain()
            }
            .customButtonStyle(.outline)
            
        }
        .padding([.vertical, .horizontal])
        .gradientBackground(.success)
    }
    
}
