//
//  MastermindFactoring.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 16/03/2026.
//

protocol MastermindFactoring {
    func makeMastermindGameStateViewModel() -> MastermindGameStateViewModel
    func makeMastermindGamePlayViewModel(mastermindGame: MastermindGame, onGameEnded: @escaping (GameResult) -> Void) -> MastermindGamePlayViewModel
}

extension Factory: MastermindFactoring {
    func makeMastermindGameStateViewModel() -> MastermindGameStateViewModel {
        MastermindGameStateViewModel(factory: self, mastermindLifecycleService: mastermindLifecycleService)
    }
    
    func makeMastermindGamePlayViewModel(mastermindGame: MastermindGame, onGameEnded: @escaping (GameResult) -> Void) -> MastermindGamePlayViewModel {
        MastermindGamePlayViewModel(mastermindGame: mastermindGame, mastermindValidationService: mastermindValidationService, onGameEnded: onGameEnded)
    }
    
}
