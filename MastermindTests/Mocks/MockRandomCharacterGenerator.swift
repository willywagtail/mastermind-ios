//
//  MockRandomCharacterGenerator.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 17/03/2026.
//

@testable import Mastermind

class MockRandomCharacterGenerator: RandomCharacterGenerating {
    var randomCalled: ((String) -> Void)?
    var randomError: Error?
    var randomResponse: Character = "A"
    var randomResponses: [Character]?
    private var callIndex = 0
    
    func random(from characters: String) throws -> Character {
        randomCalled?(characters)
        if let randomError {
            throw randomError
        }
        if let responses = randomResponses {
            defer { callIndex += 1 }
            return responses[callIndex]
        }
        return randomResponse
    }
    
}
