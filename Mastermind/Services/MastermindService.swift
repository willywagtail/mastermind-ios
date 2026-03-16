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
    case validationFailed
}

protocol MastermindServiceProtocol {
    func newGame() throws -> MastermindGame
    func validate(guess: String) throws-> ValidationResult
}

// MARK: - Mastermind Service

class MastermindService: MastermindServiceProtocol {
    
    // MARK: - Private Properties
    
    private var currentGame: MastermindGame?
    private let randomCharacterGenerator: RandomCharacterGenerating
    private let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    private let timeInSeconds: Int
    private let sequenceLength: Int
    
    // MARK: - Init
    
    init(
        timeInSeconds: Int = 60,
        sequenceLength: Int = 4,
        randomCharacterGenerator: RandomCharacterGenerating
    ) {
        self.timeInSeconds = timeInSeconds
        self.sequenceLength = sequenceLength
        self.randomCharacterGenerator = randomCharacterGenerator
    }
    
    // MARK: - Public Functions
    
    /// Validates the user's guess against the target sequence
    /// - Parameter guess: The character string guessed by the user
    /// - Returns: ValidationResult containing array of CharacterStates and win status
    func validate(guess: String) throws -> ValidationResult {
        guard let game = currentGame else { throw MastermindServiceError.gameNotFound }
        guard guess.count == sequenceLength else { throw MastermindServiceError.invalidGuessLength }

        let target = Array(game.targetSequence.uppercased())
        let guessChars = Array(guess.uppercased())

        var states = Array(repeating: CharacterState.initial, count: sequenceLength)
        var counts: [Character: Int] = [:]
        
        // Create frequency dictionary
        for char in target {
            counts[char, default: 0] += 1
        }

        // Check 1: .correct
        for i in 0..<sequenceLength {
            if guessChars[i] == target[i] {
                states[i] = .correct(guessChars[i])
                counts[guessChars[i], default: 0] -= 1
            }
        }

        // Chack 2: .contains or .notCorrect
        for i in 0..<sequenceLength {
            let char = guessChars[i]

            if case .correct = states[i] { continue }

            if counts[char, default: 0] > 0 {
                states[i] = .contains(char)
                counts[char, default: 0] -= 1
            } else {
                states[i] = .notCorrect(char)
            }
        }
        
        guard !states.contains(.initial) else { throw MastermindServiceError.validationFailed }
        return ValidationResult(states: states)
    }
    
    /// Starts a new game with a random sequence
    /// Can be used both for initial game start and restart
    /// - Returns: New MastermindGame instance with fresh sequence and time
    func newGame() throws -> MastermindGame {
        let game = MastermindGame(
            targetSequence: try generateSequence(),
            timeInSeconds: timeInSeconds
        )
        currentGame = game
        
        print("New game started with target sequence: \(game.targetSequence)")
        
        return game
    }
    
    // MARK: - Private Functions
    
    private func generateSequence() throws -> String {
        var sequence = ""
        for _ in 0..<sequenceLength {
            try sequence.append(randomCharacterGenerator.random(from: allowedCharacters))
        }
        return sequence.uppercased()
    }
    
}
