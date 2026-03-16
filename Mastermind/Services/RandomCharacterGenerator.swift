//
//  RandomCharacterGenerator.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 16/03/2026.
//

enum RandomCharacterGeneratorError: Error {
    case noCharacterAvailable
}

protocol RandomCharacterGenerating {
    func random(from characters: String) throws -> Character
}

struct RandomCharacterGenerator: RandomCharacterGenerating {
    func random(from characters: String) throws -> Character {
        
        if let randomCharacter = characters.randomElement() {
            return randomCharacter
        } else {
            throw RandomCharacterGeneratorError.noCharacterAvailable
        }
    }
    
}
