//
//  MastermindGame.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 16/03/2026.
//

struct MastermindGame {
    let targetSequence: String
    let timeInSeconds: Int
    
    init(targetSequence: String, timeInSeconds: Int) {
        self.targetSequence = targetSequence
        self.timeInSeconds = timeInSeconds
    }
    
}
