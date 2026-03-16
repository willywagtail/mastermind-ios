//
//  CharacterState.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 16/03/2026.
//

enum CharacterState: Equatable {
    case initial
    case correct(Character)
    case contains(Character)
    case notCorrect(Character)
    
    var character: Character {
        switch self {
        case .initial: return " "
        case .correct(let char), .contains(let char), .notCorrect(let char): return char
        }
    }
    
    var isCorrect: Bool {
        if case .correct = self { return true }
        return false
    }
    
}
