//
//  CodableProperties.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 16/03/2026.
//

protocol CodableProperties: Codable {
    static var placeholder: Self { get }
}

struct ConfigProperties: CodableProperties {
    let allowedCharacters: String
    let timeInSeconds: Int
    let numberOfCharacters: Int
    
    static let placeholder = ConfigProperties(
        allowedCharacters: "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
        timeInSeconds: 60,
        numberOfCharacters: 4
    )
}
