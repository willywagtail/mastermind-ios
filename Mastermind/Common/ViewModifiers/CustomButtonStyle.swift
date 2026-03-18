//
//  CustomButtonStyle.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 15/03/2026.
//

import SwiftUI

extension View {
    func customButtonStyle( _ type: ButtonType = .primary, scaleWidthToFill: Bool = true) -> some View {
        self.buttonStyle(CustomButtonStyle(type: type, scaleWidthToFill: scaleWidthToFill))
    }
    
}

// MARK: - Button Style

private struct CustomButtonStyle: PrimitiveButtonStyle {
    let type: ButtonType
    let scaleWidthToFill: Bool
    
    func makeBody(configuration: PrimitiveButtonStyle.Configuration) -> some View {
        CustomButton(configuration: configuration, type: type, scaleWidthToFill: scaleWidthToFill)
    }
}

// MARK: - Button View

private struct CustomButton: View {
    // MARK: - Environment
    
    @Environment(\.isEnabled) private var isEnabled
    
    // MARK: - Properties
    
    let configuration: PrimitiveButtonStyle.Configuration
    let type: ButtonType
    let scaleWidthToFill: Bool
    
    private var foregroundColor: Color {
        isEnabled ? type.foregroundColor : type.disabledForegroundColor
    }
    
    private var backgroundColor: Color {
        isEnabled ? type.backgroundColor : type.disabledBackgroundColor
    }
    
    private var borderColor: Color {
        isEnabled ? type.borderColor : type.disabledBorderColor
    }
    
    // MARK: - Body
    
    var body: some View {
        Button(role: configuration.role, action: configuration.trigger) {
            configuration.label
                .fixedSize(horizontal: false, vertical: true)
                .font(.headline)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .frame(minHeight: 60)
                .frame(maxWidth: scaleWidthToFill ? .infinity : nil)
        }
        .background(backgroundColor)
        .foregroundStyle(foregroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(borderColor, lineWidth: 2)
        )
        .shadow(radius: 8)
    }
    
}

// MARK: - Button Type

enum ButtonType {
    case primary
    case outline
    
    var foregroundColor: Color {
        switch self {
        case .primary: .foregroundAction
        case .outline: .foregroundAction
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .primary: .backgroundAction
        case .outline: .clear
        }
    }
    
    var borderColor: Color {
        switch self {
        case .primary: .clear
        case .outline: .foregroundAction
        }
    }
    
    var disabledForegroundColor: Color {
        switch self {
        case .primary: .foregroundDisabled
        case .outline: .foregroundDisabled
        }
    }
    
    var disabledBackgroundColor: Color {
        switch self {
        case .primary: .backgroundDisabled
        case .outline: .clear
        }
    }
    
    var disabledBorderColor: Color {
        switch self {
        case .primary: .clear
        case .outline: .backgroundDisabled
        }
    }
    
}
