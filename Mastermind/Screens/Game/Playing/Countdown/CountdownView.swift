//
//  CountDownView.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 17/03/2026.
//

import SwiftUI

struct CountdownView: View {
    // MARK: - Properties
    
    let remainingSeconds: Int
    let totalSeconds: Int
    private let lineWidth: CGFloat = 6
    private let size: CGFloat = 100
    
    // MARK: - Computed
    
    private var progress: CGFloat {
        guard totalSeconds > 0 else { return 0 }
        return CGFloat(remainingSeconds) / CGFloat(totalSeconds)
    }
    
    private var isDanger: Bool {
        remainingSeconds <= 10
    }
    
    private var circleColor: Color {
        isDanger ? .foregroundDanger : .foregroundPrimary
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(circleColor.opacity(0.2), lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    circleColor,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: remainingSeconds)
            
            Text("\(remainingSeconds)")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(circleColor)
        }
        .frame(width: size, height: size)
    }
}
