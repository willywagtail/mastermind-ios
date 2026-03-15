//
//  MastermindLandingView.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 15/03/2026.
//

import SwiftUI

struct MastermindLandingView: View {
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
                .frame(maxHeight: 72)
            
            Image(.mastermindLogo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 80)
                .accessibilityHidden(true)
            
            Spacer()
            
            NavigationLink(value: MastermindRoute.game) {
                Text(.homeStartButton)
            }
            .accessibilityLabel(.homeStartButtonAccessibilityLabel)
            .customButtonStyle()
        }
        .padding([.vertical, .horizontal])
        .gradientBackground()
    }
    
}
