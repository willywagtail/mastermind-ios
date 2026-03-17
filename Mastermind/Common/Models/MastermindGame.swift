//
//  MastermindGame.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 16/03/2026.
//

struct MastermindGame: Equatable {
    let characterStates: [CharacterState]
    let targetSequence: String
    let timeInSeconds: Int
}
