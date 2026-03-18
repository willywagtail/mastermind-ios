//
//  ValidationResult_Stub.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 17/03/2026.
//

@testable import Mastermind

extension ValidationResult {
    static var stub = ValidationResult(states: [.correct("A"), .correct("B"), .notCorrect("C"), .contains("D")])
}
