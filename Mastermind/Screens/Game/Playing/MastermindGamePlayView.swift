//
//  MastermindGamePlayView.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 16/03/2026.
//

import SwiftUI

struct MastermindGamePlayView: View {
    // MARK: - ViewModel
    
    @StateObject var viewModel: MastermindGamePlayViewModel
    
    // MARK: - State
    
    @State private var isValidateButtonEnabled = false
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Spacer()
                .frame(maxHeight: 72)
            
            Text("\(viewModel.remainingSeconds)")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(viewModel.remainingSeconds <= 10 ? .foregroundDanger : .foregroundPrimary)

            Spacer()
                .frame(maxHeight: 60)

            CharacterInputView(
                displayStates: viewModel.displayStates,
                onInputChanged: { characters in
                    viewModel.updateInputCharacters(characters)
                },
                onAllFilled: { isComplete in
                    isValidateButtonEnabled = isComplete
                },
                readOnly: false
            )

            Spacer()

            Button(.gameValidateButton) {
                viewModel.validateTapped()
            }
            .disabled(!isValidateButtonEnabled)
            .customButtonStyle()
        }
        .onAppear(perform: viewModel.onAppear)
        .padding([.vertical, .horizontal])
        .gradientBackground()
    }
    
}
