//
//  MastermindGameStateViewModelTests.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 17/03/2026.
//

import Testing

@testable import Mastermind

@MainActor
struct MastermindGameStateViewModelTests {
    
    // MARK: - Properties
    
    private var service = MockMastermindService()
    private let factory = MockFactory()
    
    // MARK: - Helpers
    
    private func makeSUT() -> MastermindGameStateViewModel {
        MastermindGameStateViewModel(
            factory: factory,
            mastermindLifecycleService: service
        )
    }
    
    // MARK: - onAppear
    
    @Test func onAppear_startsNewGame_setsPlayingState() {
        let sut = makeSUT()
        
        sut.onAppear()
        
        #expect(sut.gameState == .playing(MastermindGame.stub))
    }
    
    @Test func onAppear_whenNewGameThrows_showsAlert() {
        service.newGameError = MastermindServiceError.gameNotFound
        let sut = makeSUT()
        
        sut.onAppear()
        
        #expect(sut.gameState == .loading)
        #expect(sut.showAlert == true)
    }
    
    // MARK: - handleGameResult
    
    @Test func handleGameResult_withSuccess_setsSuccessState() {
        let solution = ValidationResult(states: [.correct("A"), .correct("B"), .correct("D"), .correct("F")])
        service.stopGameResponse = solution
        let sut = makeSUT()
        sut.onAppear()
        
        sut.handleGameResult(.success(ValidationResult(states: [.correct("A"), .correct("B"), .correct("D"), .correct("F")])))
        
        #expect(sut.gameState == .success(solution))
    }
    
    @Test func handleGameResult_withTimeExpired_setsFailureState() {
        let solution = ValidationResult(states: [.correct("A"), .correct("B"), .correct("D"), .correct("F")])
        service.stopGameResponse = solution
        let sut = makeSUT()
        sut.onAppear()
        
        sut.handleGameResult(.timeExpired)
        
        #expect(sut.gameState == .failure(solution))
    }
    
    @Test func handleGameResult_callsStopGame() {
        var stopGameWasCalled = false
        service.stopGameCalled = { stopGameWasCalled = true }
        let sut = makeSUT()
        sut.onAppear()
        
        sut.handleGameResult(.timeExpired)
        
        #expect(stopGameWasCalled)
    }
    
    // MARK: - restartTapped
    
    @Test func restartTapped_startsNewGame_setsPlayingState() {
        let sut = makeSUT()
        sut.onAppear()
        sut.handleGameResult(.timeExpired)
        
        sut.restartTapped()
        
        #expect(sut.gameState == .playing(MastermindGame.stub))
    }
    
    @Test func restartTapped_whenNewGameThrows_showsAlert() {
        let sut = makeSUT()
        sut.onAppear()
        service.newGameError = MastermindServiceError.gameNotFound
        
        sut.restartTapped()
        
        #expect(sut.showAlert == true)
    }
    
    @Test func restartTapped_callsNewGame() {
        var newGameCallCount = 0
        service.newGameCalled = { newGameCallCount += 1 }
        let sut = makeSUT()
        sut.onAppear()
        
        sut.restartTapped()
        
        #expect(newGameCallCount == 2)
    }
    
}
