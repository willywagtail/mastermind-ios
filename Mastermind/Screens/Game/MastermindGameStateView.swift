//
//  MastermindGameStateView.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 15/03/2026.
//

import SwiftUI

struct MastermindGameStateView: View {
    
    // MARK: - ViewModel
    
    @StateObject var viewModel: MastermindGameStateViewModel
    
    // MARK: - Body
    
    var body: some View {
        Group {
            switch viewModel.gameState {
            case .playing(let mastermindGame):
                MastermindGamePlayView(viewModel: viewModel.factory.makeMastermindGamePlayViewModel(mastermindGame: mastermindGame, validateCallback: viewModel.validateTapped))
                    .transition(.opacity)
            case .success(let solution):
                MastermindSuccessView(didTapPlayAgain: viewModel.restartTapped, solution: solution)
                    .transition(.opacity)
            case .fail:
                // TODO: Implement failure state
                Text("Failure:")
                    .transition(.opacity)
            case .loading:
                ProgressView()
                    .gradientBackground()
                    .transition(.opacity)
            }
            
        }
        .onAppear(perform: viewModel.onAppear)
        .animation(.easeInOut(duration: 0.3), value: viewModel.gameState)
    }
    
}
