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
    @Published var remainingSeconds: Int
    
    // MARK: - Properties
    
    private var inputCharacters: [Character]
    private let validateCallback: (String) -> ValidationResult?
    private let timeExpiredCallback: (() -> Void)
    private var timerTask: Task<Void, Never>?
    
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
        timeExpiredCallback: @escaping () -> Void,
        validateCallback: @escaping (String) -> ValidationResult?
    ) {
        self.displayStates = game.characterStates
        self.inputCharacters = game.characterStates.map { $0.character }
        self.remainingSeconds = game.timeInSeconds
        self.timeExpiredCallback = timeExpiredCallback
        self.validateCallback = validateCallback
    }
    
    deinit {
        timerTask?.cancel()
    }
    
    // MARK: - Internal
    
    func onAppear() {
        startTimer()
    }
    
    func startTimer() {
        guard timerTask == nil else { return }
        timerTask = Task {
            while remainingSeconds > 0, !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                guard !Task.isCancelled else { return }
                remainingSeconds -= 1
            }
            if remainingSeconds <= 0 {
                timeExpiredCallback()
            }
        }
    }
    
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
