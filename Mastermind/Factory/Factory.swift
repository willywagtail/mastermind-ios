//
//  Factory.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 16/03/2026.
//

class Factory {
    static let shared = Factory()
    
    lazy var configuration: Configuring = { Configuration() }()
    lazy var mastermindService: MastermindServicing = { MastermindService(configuration: configuration, randomCharacterGenerator: randomCharacterGenerator) }()
    lazy var randomCharacterGenerator: RandomCharacterGenerating = { RandomCharacterGenerator() }()
}
