//
//  MastermindGamePlayViewModelTests.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 18/03/2026.
//

import Testing

@testable import Mastermind

@MainActor
struct MastermindGamePlayViewModelTests {
    
    // MARK: - Properties
    
    private let mockService = MockMastermindService()
    
    // MARK: - Helpers
    
    private func makeSUT(
        game: MastermindGame = .stub,
        onGameEnded: @escaping (GameResult) -> Void = { _ in }
    ) -> MastermindGamePlayViewModel {
        MastermindGamePlayViewModel(
            mastermindGame: game,
            mastermindValidationService: mockService,
            onGameEnded: onGameEnded
        )
    }
    
    // MARK: - Init
    
    @Test func init_setsDisplayStatesFromGame() {
        let sut = makeSUT(onGameEnded: { _ in })
        
        #expect(sut.displayStates == MastermindGame.stub.characterStates)
    }
    
    @Test func init_setsRemainingSecondsFromGame() {
        let sut = makeSUT(onGameEnded: { _ in })
        
        #expect(sut.remainingSeconds == MastermindGame.stub.timeInSeconds)
        #expect(sut.totalSeconds == MastermindGame.stub.timeInSeconds)
    }
    
    // MARK: - updateInputCharacters
    
    @Test func updateInputCharacters_updatesCurrentGuess() {
        let sut = makeSUT(onGameEnded: { _ in })
        
        sut.updateInputCharacters(["A", "B", "C", "D"])
        
        #expect(sut.currentGuess == "ABCD")
        #expect(sut.isValidGuess == true)
    }
    
    // MARK: - clearCharacterState
    
    @Test func clearCharacterState_resetsToNeutral() {
        let sut = makeSUT(onGameEnded: { _ in })
        
        sut.clearCharacterState(at: 0)
        
        #expect(sut.displayStates[0] == .neutral(Character(" ")))
    }
    
    @Test func clearCharacterState_outOfBounds_doesNothing() {
        let sut = makeSUT(onGameEnded: { _ in })
        let originalStates = sut.displayStates
        
        sut.clearCharacterState(at: 99)
        
        #expect(sut.displayStates == originalStates)
    }
    
    // MARK: - validateTapped
    
    @Test func validateTapped_withValidGuess_callsServiceAndUpdatesDisplayStates() {
        let expectedResult = ValidationResult(states: [.correct("A"), .notCorrect("B"), .contains("C"), .notCorrect("D")])
        mockService.validateResponse = expectedResult
        let sut = makeSUT(onGameEnded: { _ in })
        sut.updateInputCharacters(["A", "B", "C", "D"])
        
        sut.validateTapped()
        
        #expect(sut.displayStates == expectedResult.states)
    }
    
    @Test func validateTapped_withValidGuess_passesFormattedGuessToService() {
        var receivedGuess: String?
        mockService.validateCalled = { guess in receivedGuess = guess }
        let sut = makeSUT(onGameEnded: { _ in })
        sut.updateInputCharacters(["a", "b", "c", "d"])
        
        sut.validateTapped()
        
        #expect(receivedGuess == "ABCD")
    }
    
    @Test func validateTapped_withSuccessResult_callsOnGameEnded() {
        let successResult = ValidationResult(states: [.correct("A"), .correct("B"), .correct("C"), .correct("D")])
        mockService.validateResponse = successResult
        var receivedResult: GameResult?
        let sut = makeSUT(onGameEnded: { result in receivedResult = result })
        sut.updateInputCharacters(["A", "B", "C", "D"])
        
        sut.validateTapped()
        
        #expect(receivedResult == .success(successResult))
    }
    
    @Test func validateTapped_withFailedResult_doesNotCallOnGameEnded() {
        let failedResult = ValidationResult(states: [.correct("A"), .notCorrect("B"), .contains("C"), .notCorrect("D")])
        mockService.validateResponse = failedResult
        var onGameEndedCalled = false
        let sut = makeSUT(onGameEnded: { _ in onGameEndedCalled = true })
        sut.updateInputCharacters(["A", "B", "C", "D"])
        
        sut.validateTapped()
        
        #expect(onGameEndedCalled == false)
    }
    
    @Test func validateTapped_withIncompleteGuess_doesNotCallService() {
        var validateCalled = false
        mockService.validateCalled = { _ in validateCalled = true }
        let sut = makeSUT(onGameEnded: { _ in })
        
        sut.validateTapped()
        
        #expect(validateCalled == false)
    }
    
    @Test func validateTapped_whenServiceThrows_doesNotUpdateDisplayStates() {
        mockService.validateError = MastermindServiceError.validationFailed
        let sut = makeSUT(onGameEnded: { _ in })
        let originalStates = sut.displayStates
        sut.updateInputCharacters(["A", "B", "C", "D"])
        
        sut.validateTapped()
        
        #expect(sut.displayStates == originalStates)
    }
    
    // MARK: - Timer
    
    @Test func onAppear_startsTimer_countingDown() async {
        let game = MastermindGame(
            characterStates: [.neutral(" ")],
            targetSequence: "A",
            timeInSeconds: 2
        )
        let sut = makeSUT(game: game, onGameEnded: { _ in })
        
        sut.onAppear()
        try? await Task.sleep(for: .milliseconds(1500))
        
        #expect(sut.remainingSeconds < 2)
    }
    
    @Test func timer_whenExpired_callsOnGameEndedWithTimeExpired() async {
        let game = MastermindGame(
            characterStates: [.neutral(" ")],
            targetSequence: "A",
            timeInSeconds: 1
        )
        var receivedResult: GameResult?
        let sut = makeSUT(game: game, onGameEnded: { result in receivedResult = result })
        
        sut.onAppear()
        try? await Task.sleep(for: .milliseconds(1500))
        
        #expect(receivedResult == .timeExpired)
    }
    
}

