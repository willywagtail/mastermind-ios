//
//  ConfigurationMock.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 17/03/2026.
//

@testable import Mastermind

class MockConfiguration: Configuring {
    var allowedCharacters: String = "ABCD"
    var timeInSeconds: Int = 60
    var numberOfCharacters: Int = 4
}
