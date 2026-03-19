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
    @Published var isValidGuess = false
    
    // MARK: - Properties
    
    let totalSeconds: Int
    private var inputCharacters: [Character]
    private let mastermindValidationService: MastermindValidationServicing
    private let onGameEnded: (GameResult) -> Void
    private var timerTask: Task<Void, Never>?
    
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
        print("DEINIT CALLED")
        timerTask?.cancel()
    }
    
    // MARK: - Internal
    
    func onAppear() {
        startTimer()
    }
    
    func updateInputCharacters(_ characters: [Character]) {
        inputCharacters = characters
        isValidGuess = characters.allSatisfy { !$0.isWhitespace }
    }
    
    func clearCharacterState(at index: Int) {
        guard displayStates.indices.contains(index) else { return }
        displayStates[index] = .neutral(Character(" "))
    }
    
    func validateTapped() {
        guard isValidGuess else { return }
        let guess = String(inputCharacters).uppercased()
        guard let result = try? mastermindValidationService.validate(guess: guess) else { return }
        displayStates = result.states
        
        if result.isSuccess {
            stopTimer()
            onGameEnded(.success(result))
        }
    }
    
    // MARK: - Private
    
    private func startTimer() {
        guard timerTask == nil else { return }
        timerTask = Task { [weak self] in
            while let self, remainingSeconds > 0, !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                guard !Task.isCancelled else { return }
                self.remainingSeconds -= 1
            }
            if let self, remainingSeconds <= 0, !Task.isCancelled {
                onGameEnded(.timeExpired)
            }
        }
    }
    
    private func stopTimer() {
        timerTask?.cancel()
        timerTask = nil
    }
    
}
