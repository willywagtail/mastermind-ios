//
//  PropertyListReader.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 16/03/2026.
//

import Foundation

protocol PropertyListReading {
    func decode<T: CodableProperties>(_ plist: PropertyList) -> T
}

enum PropertyList: String {
    case config = "Configuration"
}

class PropertyListReader: PropertyListReading {
    func decode<T: CodableProperties>(_ plist: PropertyList) -> T {
        guard let path = Bundle.main.path(forResource: plist.rawValue, ofType: "plist"),
              let data = FileManager.default.contents(atPath: path) else {
            assertionFailure("\(plist.rawValue).plist file not found")
            return T.placeholder
        }
        
        do {
            let properties = try PropertyListDecoder().decode(T.self, from: data)
            return properties
        } catch {
            assertionFailure("\(plist.rawValue).plist parsing Error \(error)")
            return T.placeholder
        }
    }
    
}
