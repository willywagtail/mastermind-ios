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
                MastermindGamePlayView(
                    viewModel: viewModel.factory.makeMastermindGamePlayViewModel(
                        mastermindGame: mastermindGame,
                        onGameEnded: viewModel.handleGameResult
                    )
                )
                .id(mastermindGame)
                .transition(.opacity)
                
            case .success(let result):
                MastermindResultView(didTapPlayAgain: viewModel.restartTapped, result: .success(result))
                    .transition(.opacity)
            case .failure(let result):
                MastermindResultView(didTapPlayAgain: viewModel.restartTapped, result: .failure(result))
                    .transition(.opacity)
            case .loading:
                ProgressView()
                    .gradientBackground()
                    .transition(.opacity)
            }
            
        }
        .onAppear(perform: viewModel.onAppear)
        .animation(.easeInOut(duration: 0.3), value: viewModel.gameState)
        .alert(.alertTitleLabel, isPresented: $viewModel.showAlert) {
            Button(.alertActionLabel) {
                viewModel.restartTapped()
            }
        }
    }
    
}
