//
//  MastermindFactoring.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 16/03/2026.
//

protocol MastermindFactoring {
    func makeMastermindGameStateViewModel() -> MastermindGameStateViewModel
    func makeMastermindGamePlayViewModel(mastermindGame: MastermindGame, timeExpiredCallback: @escaping () -> Void, validateCallback: @escaping (String) -> ValidationResult?) -> MastermindGamePlayViewModel
}

extension Factory: MastermindFactoring {
    func makeMastermindGameStateViewModel() -> MastermindGameStateViewModel {
        MastermindGameStateViewModel(factory: self, mastermindService: mastermindService)
    }
    
    func makeMastermindGamePlayViewModel(mastermindGame: MastermindGame, timeExpiredCallback: @escaping () -> Void, validateCallback: @escaping (String) -> ValidationResult?) -> MastermindGamePlayViewModel {
        return MastermindGamePlayViewModel(game: mastermindGame, timeExpiredCallback: timeExpiredCallback, validateCallback: validateCallback)
    }
    
}
