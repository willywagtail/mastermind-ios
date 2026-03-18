//
//  CharacterState.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 16/03/2026.
//

enum CharacterState: Equatable, Hashable {
    case neutral(Character)
    case correct(Character)
    case contains(Character)
    case notCorrect(Character)
    
    var character: Character {
        switch self {
        case .neutral(let char), .correct(let char), .contains(let char), .notCorrect(let char): return char
        }
    }
    
    var isCorrect: Bool {
        if case .correct = self { return true }
        return false
    }
    
    var isNeutral: Bool {
        if case .neutral = self { return true }
        return false
    }
    
}
