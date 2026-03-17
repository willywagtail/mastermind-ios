//
//  MastermindGameStateViewModel.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 16/03/2026.
//

import Combine
import Foundation

@MainActor
class MastermindGameStateViewModel: ObservableObject {
    // MARK: - Published
    
    @Published var gameState: GameState = .loading
    
    // MARK: - Properties
    
    let factory: MastermindFactoring
    private let mastermindService: MastermindServicing
    
    // MARK: - Lifecycle
    
    init(
        factory: MastermindFactoring,
        mastermindService: MastermindServicing
    ) {
        self.factory = factory
        self.mastermindService = mastermindService
    }
    
    // MARK: - Internal
    
    func onAppear() {
        do {
            let mastermindGame = try mastermindService.newGame()
            gameState = .playing(mastermindGame)
        } catch {
            // TODO: Add alert
        }
    }
    
    func validateTapped(guess: String) -> ValidationResult? {
        do {
            let result = try mastermindService.validate(guess: guess)
            if result.isSuccess {
                gameState = .success(result)
            }
            return result
        } catch {
            return nil
            // TODO: Add alert
        }
    }
    
    func restartTapped() {
        do {
            let mastermindGame = try mastermindService.newGame()
            gameState = .playing(mastermindGame)
        } catch {
            // TODO: Add alert
        }
    }
    
    func stopGame() {
        let solution = mastermindService.stopGame()
        gameState = .fail(solution)
    }
    
}
