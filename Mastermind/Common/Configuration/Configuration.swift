//
//  Configuring.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 16/03/2026.
//

protocol Configuring {
    var allowedCharacters: String { get }
    var timeInSeconds: Int { get }
    var numberOfCharacters: Int { get }
}

struct Configuration: Configuring {
    private let propertyListReader = PropertyListReader()
    private var configuration: ConfigProperties {
        propertyListReader.decode(.config)
    }
    
    // MARK: Configuration Properties
    
    var allowedCharacters: String {
        configuration.allowedCharacters
    }
    
    var timeInSeconds: Int {
        configuration.timeInSeconds
    }
    
    var numberOfCharacters: Int {
        configuration.numberOfCharacters
    }
    
}
