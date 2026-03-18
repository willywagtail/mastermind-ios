//
//  MastermindServiceTests.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 18/03/2026.
//

import Testing

@testable import Mastermind

struct MastermindServiceTests {
    
    // MARK: - Properties
    
    private let mockConfiguration = MockConfiguration()
    private let mockGenerator = MockRandomCharacterGenerator()
    
    // MARK: - Helpers
    
    private func makeSUT() -> MastermindService {
        MastermindService(
            configuration: mockConfiguration,
            randomCharacterGenerator: mockGenerator
        )
    }
    
    // MARK: - newGame
    
    @Test func newGame_returnsGameWithCorrectNumberOfCharacters() throws {
        let sut = makeSUT()
        
        let game = try sut.newGame()
        
        #expect(game.characterStates.count == mockConfiguration.numberOfCharacters)
    }
    
    @Test func newGame_returnsGameWithNeutralStates() throws {
        let sut = makeSUT()
        
        let game = try sut.newGame()
        
        let allNeutral = game.characterStates.allSatisfy {
            if case .neutral = $0 { return true }
            return false
        }
        #expect(allNeutral)
    }
    
    @Test func newGame_returnsGameWithConfiguredTime() throws {
        mockConfiguration.timeInSeconds = 30
        let sut = makeSUT()
        
        let game = try sut.newGame()
        
        #expect(game.timeInSeconds == 30)
    }
    
    @Test func newGame_generatesUppercasedTargetSequence() throws {
        mockGenerator.randomResponse = "a"
        let sut = makeSUT()
        
        let game = try sut.newGame()
        
        #expect(game.targetSequence == "AAAA")
    }
    
    @Test func newGame_usesRandomGenerator() throws {
        var callCount = 0
        mockGenerator.randomCalled = { _ in callCount += 1 }
        let sut = makeSUT()
        
        _ = try sut.newGame()
        
        #expect(callCount == mockConfiguration.numberOfCharacters)
    }
    
    @Test func newGame_whenGeneratorThrows_propagatesError() {
        mockGenerator.randomError = RandomCharacterGeneratorError.noCharacterAvailable
        let sut = makeSUT()
        
        #expect(throws: RandomCharacterGeneratorError.noCharacterAvailable) {
            try sut.newGame()
        }
    }
    
    // MARK: - validate
    
    @Test func validate_withoutGame_throwsGameNotFound() {
        let sut = makeSUT()
        
        #expect(throws: MastermindServiceError.gameNotFound) {
            try sut.validate(guess: "ABCD")
        }
    }
    
    @Test func validate_withWrongLength_throwsInvalidGuessLength() throws {
        let sut = makeSUT()
        _ = try sut.newGame()
        
        #expect(throws: MastermindServiceError.invalidGuessLength) {
            try sut.validate(guess: "AB")
        }
    }
    
    @Test func validate_withExactMatch_returnsAllCorrect() throws {
        mockGenerator.randomResponse = "A"
        let sut = makeSUT()
        _ = try sut.newGame() // target = "AAAA"
        
        let result = try sut.validate(guess: "AAAA")
        
        #expect(result.isSuccess)
        #expect(result.states == [.correct("A"), .correct("A"), .correct("A"), .correct("A")])
    }
    
    @Test func validate_withNoMatches_returnsAllNotCorrect() throws {
        mockGenerator.randomResponse = "A"
        mockConfiguration.allowedCharacters = "AB"
        let sut = makeSUT()
        _ = try sut.newGame() // target = "AAAA"
        
        let result = try sut.validate(guess: "BBBB")
        
        #expect(result.states == [.notCorrect("B"), .notCorrect("B"), .notCorrect("B"), .notCorrect("B")])
    }
    
    @Test func validate_withContainedCharacter_returnsContains() throws {
        mockConfiguration.numberOfCharacters = 2
        mockConfiguration.allowedCharacters = "AB"
        mockGenerator.randomResponses = ["B", "A"]
        let sut = makeSUT()
        _ = try sut.newGame() // target = "BA"
        
        let result = try sut.validate(guess: "AB")
        
        #expect(result.states == [.contains("A"), .contains("B")])
    }
    
    @Test func validate_withMixedResult_returnsCorrectStates() throws {
        mockConfiguration.numberOfCharacters = 3
        mockConfiguration.allowedCharacters = "ABC"
        mockGenerator.randomResponses = ["A", "B", "C"]
        let sut = makeSUT()
        _ = try sut.newGame() // target = "ABC"
        
        let result = try sut.validate(guess: "AXB")
        
        #expect(result.states[0] == .correct("A"))
        #expect(result.states[1] == .notCorrect("X"))
        #expect(result.states[2] == .contains("B"))
    }
    
    @Test func validate_isCaseInsensitive() throws {
        mockGenerator.randomResponse = "A"
        let sut = makeSUT()
        _ = try sut.newGame() // target = "AAAA"
        
        let result = try sut.validate(guess: "aaaa")
        
        #expect(result.isSuccess)
    }
    
    @Test func validate_containsDoesNotExceedFrequency() throws {
        // Target: "ABCC" — guess: "CCCA"
        // C at index 0: not in position, count=2, so .contains, count→1
        // C at index 1: not in position, count=1, so .contains, count→0
        // C at index 2: correct position, already counted in first pass
        // A at index 3: not in position, count=1 A appears once, so .contains
        mockConfiguration.numberOfCharacters = 4
        mockConfiguration.allowedCharacters = "ABC"
        mockGenerator.randomResponses = ["A", "B", "C", "C"]
        let sut = makeSUT()
        _ = try sut.newGame() // target = "ABCC"
        
        let result = try sut.validate(guess: "CCCA")
        
        // C at 0: contains (one C left after correct C at index 2 and 3)
        // C at 1: notCorrect (no more C's available)
        // C at 2: correct
        // A at 3: contains
        #expect(result.states[0] == .contains("C"))
        #expect(result.states[1] == .notCorrect("C"))
        #expect(result.states[2] == .correct("C"))
        #expect(result.states[3] == .contains("A"))
    }
    
    // MARK: - stopGame
    
    @Test func stopGame_returnsCorrectSolution() throws {
        mockGenerator.randomResponse = "A"
        let sut = makeSUT()
        _ = try sut.newGame() // target = "AAAA"
        
        let result = sut.stopGame()
        
        #expect(result.states == [.correct("A"), .correct("A"), .correct("A"), .correct("A")])
    }
    
    @Test func stopGame_withoutGame_returnsEmptyStates() {
        let sut = makeSUT()
        
        let result = sut.stopGame()
        
        #expect(result.states.isEmpty)
    }
    
    @Test func stopGame_clearsCurrentGame() throws {
        let sut = makeSUT()
        _ = try sut.newGame()
        _ = sut.stopGame()
        
        #expect(throws: MastermindServiceError.gameNotFound) {
            try sut.validate(guess: "AAAA")
        }
    }
    
}
