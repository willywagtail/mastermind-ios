//
//  ValidationResult.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 16/03/2026.
//

struct ValidationResult {
    let states: [CharacterState]
    
    init(states: [CharacterState]) {
        self.states = states
    }
    
}

extension ValidationResult {
    var isSuccess: Bool {
        states.allSatisfy { $0.isCorrect }
    }
    
}
