//
//  MastermindGamePlayViewModel.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 16/03/2026.
//

import Foundation
import Combine

@MainActor
class MastermindGamePlayViewModel: ObservableObject {
    // MARK: - Published
    
    @Published var displayStates: [CharacterState]
    
    // MARK: - Properties
    
    private var inputCharacters: [Character]
    private let validateCallback: (String) -> ValidationResult?
    
    // MARK: - Computed
    
    var currentGuess: String {
        String(inputCharacters)
    }

    var isValidGuess: Bool {
        inputCharacters.allSatisfy { !$0.isWhitespace }
    }

    // MARK: - Lifecycle
    
    init(
        game: MastermindGame,
        validateCallback: @escaping (String) -> ValidationResult?
    ) {
        self.displayStates = game.characterStates
        self.inputCharacters = game.characterStates.map { $0.character }
        self.validateCallback = validateCallback
    }
    
    // MARK: - Internal
    
    func updateInputCharacters(_ characters: [Character]) {
        inputCharacters = characters
    }

    func validateTapped() {
        // Extra validation
        guard isValidGuess else { return }
        let formattedGuess = currentGuess.trimmingCharacters(in: .whitespaces).uppercased()
        guard formattedGuess.count == displayStates.count else { return }
        
        if let result = validateCallback(formattedGuess) {
            displayStates = result.states
        }
    }
}
