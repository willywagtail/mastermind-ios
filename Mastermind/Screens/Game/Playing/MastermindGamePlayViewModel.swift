//
//  MastermindGamePlayViewModel.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 16/03/2026.
//

import Foundation
import Combine

enum GameResult: Equatable {
    case success(ValidationResult)
    case timeExpired
}

@MainActor
class MastermindGamePlayViewModel: ObservableObject {
    // MARK: - Published
    
    @Published var displayStates: [CharacterState]
    @Published var remainingSeconds: Int
    
    // MARK: - Properties
    
    let totalSeconds: Int
    private var inputCharacters: [Character]
    private let mastermindValidationService: MastermindValidationServicing
    private let onGameEnded: (GameResult) -> Void
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
        mastermindGame: MastermindGame,
        mastermindValidationService: MastermindValidationServicing,
        onGameEnded: @escaping (GameResult) -> Void
    ) {
        self.displayStates = mastermindGame.characterStates
        self.inputCharacters = mastermindGame.characterStates.map { $0.character }
        self.totalSeconds = mastermindGame.timeInSeconds
        self.remainingSeconds = mastermindGame.timeInSeconds
        self.mastermindValidationService = mastermindValidationService
        self.onGameEnded = onGameEnded
    }
    
    deinit {
        timerTask?.cancel()
    }
    
    // MARK: - Internal
    
    func onAppear() {
        startTimer()
    }
    
    func updateInputCharacters(_ characters: [Character]) {
        inputCharacters = characters
    }
    
    func clearCharacterState(at index: Int) {
        guard displayStates.indices.contains(index) else { return }
        displayStates[index] = .neutral(Character(" "))
    }
    
    func validateTapped() {
        guard isValidGuess else { return }
        let formattedGuess = currentGuess.trimmingCharacters(in: .whitespaces).uppercased()
        guard formattedGuess.count == displayStates.count else { return }
        
        guard let result = try? mastermindValidationService.validate(guess: formattedGuess) else { return }
        displayStates = result.states
        
        if result.isSuccess {
            stopTimer()
            onGameEnded(.success(result))
        }
    }
    
    // MARK: - Private
    
    private func startTimer() {
        guard timerTask == nil else { return }
        timerTask = Task {
            while remainingSeconds > 0, !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                guard !Task.isCancelled else { return }
                remainingSeconds -= 1
            }
            if remainingSeconds <= 0, !Task.isCancelled {
                onGameEnded(.timeExpired)
            }
        }
    }
    
    private func stopTimer() {
        timerTask?.cancel()
        timerTask = nil
    }
}
