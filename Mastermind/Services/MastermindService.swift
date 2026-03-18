//
//  MastermindService.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 16/03/2026.
//

import Foundation

enum MastermindServiceError: Error {
    case gameNotFound
    case invalidGuessLength

}

protocol MastermingLifecycleServicing {
    func newGame() throws -> MastermindGame
    func stopGame() -> ValidationResult
}

protocol MastermindValidationServicing {
    func validate(guess: String) throws -> ValidationResult
}

typealias MastermindServicing = MastermingLifecycleServicing & MastermindValidationServicing

// MARK: - Mastermind Service

class MastermindService: MastermindServicing {
    
    // MARK: - Private Properties
    
    private let allowedCharacters: String
    private var currentGame: MastermindGame?
    private let randomCharacterGenerator: RandomCharacterGenerating
    private let numberOfCharacters: Int
    private let timeInSeconds: Int
    
    // MARK: - Init
    
    init(
        configuration: Configuring,
        randomCharacterGenerator: RandomCharacterGenerating
    ) {
        self.allowedCharacters = configuration.allowedCharacters
        self.numberOfCharacters = configuration.numberOfCharacters
        self.timeInSeconds = configuration.timeInSeconds
        self.randomCharacterGenerator = randomCharacterGenerator
    }
    
    // MARK: - Public Functions
    
    /// Validates the user's guess against the target sequence
    /// - Parameter guess: The character string guessed by the user
    /// - Returns: ValidationResult containing array of CharacterStates and computed success status
    func validate(guess: String) throws -> ValidationResult {
        guard let game = currentGame else { throw MastermindServiceError.gameNotFound }
        guard guess.count == numberOfCharacters else { throw MastermindServiceError.invalidGuessLength }

        let target = Array(game.targetSequence.uppercased())
        let guessChars = Array(guess.uppercased())

        var states = Array(repeating: CharacterState.neutral(" "), count: numberOfCharacters)
        var counts = target.reduce(into: [:]) { counts, character in
            counts[character, default: 0] += 1
        }

        // Check 1: .correct
        for i in 0..<numberOfCharacters where guessChars[i] == target[i] {
            states[i] = .correct(guessChars[i])
            counts[guessChars[i], default: 0] -= 1
        }

        // Check 2: .contains or .notCorrect
        for i in 0..<numberOfCharacters {
            let char = guessChars[i]

            if case .correct = states[i] { continue }

            if counts[char, default: 0] > 0 {
                states[i] = .contains(char)
                counts[char, default: 0] -= 1
            } else {
                states[i] = .notCorrect(char)
            }
        }

        return ValidationResult(states: states)
    }
    
    /// Starts a new game with a random sequence
    /// Can be used both for initial game start and restart
    /// - Returns: New MastermindGame instance with fresh sequence and time
    func newGame() throws -> MastermindGame {
        let initialState = Array(
            repeating: CharacterState.neutral(" "),
            count: numberOfCharacters
        )
        
        let mastermindGame = MastermindGame(
            characterStates: initialState,
            targetSequence: try generateSequence(),
            timeInSeconds: timeInSeconds
        )
        currentGame = mastermindGame
        
        print("New game started with target sequence: \(mastermindGame.targetSequence)")
        
        return mastermindGame
    }
    
    /// Stops the current MastermindGame and deallocates it
    /// - Returns: The correct sequence in a ValidationResult
    func stopGame() -> ValidationResult {
        defer { currentGame = nil }
        let solution = currentGame?.targetSequence.map { CharacterState.correct($0) } ?? []
        return ValidationResult(states: solution)
        
    }
    
    // MARK: - Private Functions
    
    private func generateSequence() throws -> String {
        var sequence = ""
        for _ in 0..<numberOfCharacters {
            try sequence.append(randomCharacterGenerator.random(from: allowedCharacters))
        }
        return sequence.uppercased()
    }
    
}
