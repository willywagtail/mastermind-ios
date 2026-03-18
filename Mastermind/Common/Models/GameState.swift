//
//  GameState.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 15/03/2026.
//

enum GameState: Equatable {
    case playing(MastermindGame)
    case success(ValidationResult)
    case failure(ValidationResult)
    case loading
}
