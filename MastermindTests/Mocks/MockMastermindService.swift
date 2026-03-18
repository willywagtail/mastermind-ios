//
//  MockMastermindService.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 17/03/2026.
//

@testable import Mastermind

class MockMastermindService: MastermindServicing {
    var newGameCalled: (() -> Void)?
    var newGameError: Error?
    var newGameResponse = MastermindGame.stub
    func newGame() throws -> MastermindGame {
        newGameCalled?()
        if let newGameError {
            throw newGameError
        }
        return newGameResponse
    }
    
    var validateCalled: ((String) -> Void)?
    var validateError: Error?
    var validateResponse = ValidationResult.stub
    func validate(guess: String) throws -> ValidationResult {
        validateCalled?(guess)
        if let validateError {
            throw validateError
        }
        return validateResponse
    }
    
    var stopGameCalled: (() -> Void)?
    var stopGameResponse = ValidationResult.stub
    func stopGame() -> ValidationResult {
        stopGameCalled?()
        return stopGameResponse
    }
    
}
