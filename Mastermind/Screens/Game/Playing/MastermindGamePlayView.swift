//
//  MastermindGamePlayView.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 16/03/2026.
//

import SwiftUI

struct MastermindGamePlayView: View {
    // MARK: - ViewModel
    
    @State var viewModel: MastermindGamePlayViewModel
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Spacer()
                .frame(maxHeight: 44)
            
            CountdownView(
                remainingSeconds: viewModel.remainingSeconds,
                totalSeconds: viewModel.totalSeconds
            )
            .accessibilityHidden(true)

            Spacer()
                .frame(maxHeight: 60)

            CharacterInputView(
                displayStates: viewModel.displayStates,
                onInputChanged: { characters in
                    viewModel.updateInputCharacters(characters)
                },
                onCharacterCleared: { index in
                    viewModel.clearCharacterState(at: index)
                },
                readOnly: false
            )

            Spacer()

            Button(.gameValidateButton) {
                viewModel.validateTapped()
            }
            .disabled(!viewModel.isValidGuess)
            .customButtonStyle()
        }
        .onAppear(perform: viewModel.onAppear)
        .padding([.vertical, .horizontal])
        .gradientBackground()
    }
    
}
