//
//  MastermindGameStateViewModel.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 16/03/2026.
//

import Foundation

@MainActor
@Observable
class MastermindGameStateViewModel {
    // MARK: - Properties
    
    var gameState: GameState = .loading
    var showAlert = false
    @ObservationIgnored let factory: MastermindFactoring
    @ObservationIgnored private let mastermindLifecycleService: MastermindLifecycleServicing
    
    // MARK: - Lifecycle
    
    init(
        factory: MastermindFactoring,
        mastermindLifecycleService: MastermindLifecycleServicing
    ) {
        self.factory = factory
        self.mastermindLifecycleService = mastermindLifecycleService
    }
    
    // MARK: - Internal
    
    func onAppear() {
        startNewGame()
    }
    
    func handleGameResult(_ result: GameResult) {
        let solution = mastermindLifecycleService.stopGame()
        switch result {
        case .success:
            gameState = .success(solution)
        case .timeExpired:
            gameState = .failure(solution)
        }
    }
    
    func restartTapped() {
        startNewGame()
    }
    
    // MARK: - Private
    
    private func startNewGame() {
        do {
            let mastermindGame = try mastermindLifecycleService.newGame()
            gameState = .playing(mastermindGame)
        } catch {
            showAlert = true
        }
    }
    
}
