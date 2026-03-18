//
//  Factory.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 16/03/2026.
//

class Factory {
    static let shared = Factory()
    
    lazy var configuration: Configuring = { Configuration() }()
    lazy var mastermindLifecycleService: MastermindLifecycleServicing = { mastermindService }()
    lazy var mastermindValidationService: MastermindValidationServicing = { mastermindService }()
    lazy var randomCharacterGenerator: RandomCharacterGenerating = { RandomCharacterGenerator() }()
    
    private lazy var mastermindService: MastermindServicing = { MastermindService(configuration: configuration, randomCharacterGenerator: randomCharacterGenerator) }()
}
