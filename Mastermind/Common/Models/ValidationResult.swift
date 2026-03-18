//
//  ValidationResult.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 16/03/2026.
//

struct ValidationResult: Equatable {
    let states: [CharacterState]
}

extension ValidationResult {
    var isSuccess: Bool {
        states.allSatisfy { $0.isCorrect }
    }
    
    var neutralResult: [CharacterState] {
        states.map { CharacterState.neutral($0.character) }
    }
    
}
