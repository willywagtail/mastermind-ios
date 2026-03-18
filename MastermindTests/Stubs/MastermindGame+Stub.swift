//
//  MastermindGame+Stub.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 17/03/2026.
//

@testable import Mastermind

extension MastermindGame {
    static var stub = MastermindGame(characterStates: [.neutral(" "), .neutral(" "), .neutral(" "), .neutral(" ")],
                                     targetSequence: "ABDF",
                                     timeInSeconds: 10)
}
