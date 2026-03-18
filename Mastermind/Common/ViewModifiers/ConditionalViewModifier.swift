//
//  ConditionalViewModifier.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 18/03/2026.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
}
