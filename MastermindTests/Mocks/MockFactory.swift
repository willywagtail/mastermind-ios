//
//  MockFactory.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 18/03/2026.
//

@testable import Mastermind

class MockFactory: MastermindFactoring {
    func makeMastermindGameStateViewModel() -> MastermindGameStateViewModel {
        fatalError("Not needed in these tests")
    }
    
    func makeMastermindGamePlayViewModel(mastermindGame: MastermindGame, onGameEnded: @escaping (GameResult) -> Void) -> MastermindGamePlayViewModel {
        fatalError("Not needed in these tests")
    }
    
}
