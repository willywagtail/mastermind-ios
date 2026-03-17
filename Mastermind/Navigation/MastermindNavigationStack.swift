//
//  MastermindNavigationStack.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 15/03/2026.
//

import Foundation
import SwiftUI

struct MastermindNavigationStack: View {
    
    // MARK: - Path
    
    @State private var path: [MastermindRoute] = []
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack(path: $path) {
            MastermindLandingView()
            
            // MARK: - MastermindRoute
                .navigationDestination(for: MastermindRoute.self) { route in
                    switch route {
                    case .playGame:
                        MastermindGameStateView(viewModel: Factory.shared.makeMastermindGameStateViewModel())
                    }
                }
        }
    }
    
}
