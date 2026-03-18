//
//  CharactersInputView.swift
//  Mastermind
//
//  Created by Stijn Ergeerts on 16/03/2026.
//

import SwiftUI
import UIKit

// MARK: - CharacterInputView

struct CharacterInputView: View {
    // MARK: - State
    
    @State private var letters: [Character?] = []
    @State private var focusedIndex: Int = 0
    @State private var keyboardActive = false
    
    // MARK: - Properties
    
    let displayStates: [CharacterState]
    var onInputChanged: (([Character]) -> Void)?
    var onCharacterCleared: ((Int) -> Void)?
    let readOnly: Bool
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            if !readOnly {
                KeyInputRepresentable(
                    isActive: keyboardActive,
                    onInsert: handleInsert,
                    onDelete: handleDelete
                )
                .frame(width: 1, height: 1)
                .opacity(0)
            }

            HStack(spacing: 12) {
                ForEach(displayStates.indices, id: \.self) { index in
                    if letters.indices.contains(index) {
                        characterBox(at: index)
                            .onTapGesture {
                                guard !readOnly else { return }
                                focusedIndex = index
                                keyboardActive = true
                            }
                    }
                }
            }
        }
        .onAppear {
            letters = displayStates.map { $0.character.isWhitespace ? nil : $0.character }
            focusedIndex = letters.firstIndex(where: { $0 == nil }) ?? 0
            keyboardActive = !readOnly
        }
        .onChange(of: displayStates) { newStates in
            guard newStates.allSatisfy({ !$0.isNeutral }) else { return }
            letters = newStates.map { $0.character }
            
            if newStates.allSatisfy(\.isCorrect) {
                keyboardActive = false
            }
        }
    }

    // MARK: - Character Box

    @ViewBuilder
    private func characterBox(at index: Int) -> some View {
        let isFocused = !readOnly && focusedIndex == index
        let displayText = letters[index].map { String($0).uppercased() } ?? ""

        Text(displayText)
            .font(.system(size: 24, weight: .semibold))
            .foregroundStyle(.foregroundPrimary)
            .frame(width: 56, height: 56)
            .background(backgroundColor(for: displayStates[index]))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        isFocused ? Color.accentColor : .backgroundNeutral.opacity(0.6),
                        lineWidth: isFocused ? 2 : 1
                    )
            )
            .accessibilityLabel(accessibilityLabel(at: index))
            .accessibilityValue(displayText.isEmpty ? "empty" : displayText)
            .accessibilityHint(readOnly ? "" : String(localized: "character_box_accessibility_hint \(index + 1) \(displayStates.count)"))
            .accessibilityAddTraits(readOnly ? .isStaticText : .isButton)
            .if(!readOnly) { view in
                view.accessibilityAction {
                    focusedIndex = index
                    keyboardActive = true
                }
            }
    }

    // MARK: - Character Handling

    private func handleInsert(_ text: String) {
        guard focusedIndex < letters.count,
              let char = text.first(where: \.isLetter) else { return }

        letters[focusedIndex] = Character(char.uppercased())

        if focusedIndex + 1 < letters.count {
            focusedIndex += 1
        }

        notifyInputChanged()
    }

    private func handleDelete() {
        guard letters.indices.contains(focusedIndex) else { return }

        if letters[focusedIndex] != nil {
            letters[focusedIndex] = nil
            onCharacterCleared?(focusedIndex)
        } else if focusedIndex > 0 {
            focusedIndex -= 1
            letters[focusedIndex] = nil
            onCharacterCleared?(focusedIndex)
        }

        notifyInputChanged()
    }

    // MARK: - Helpers

    private func notifyInputChanged() {
        let characters = letters.map { $0 ?? Character(" ") }
        onInputChanged?(characters)
    }

    private func backgroundColor(for state: CharacterState) -> Color {
        switch state {
        case .correct: .backgroundSuccess.opacity(0.8)
        case .contains: .backgroundWarning.opacity(0.8)
        case .notCorrect: .backgroundFailure.opacity(0.8)
        case .neutral: .backgroundNeutral.opacity(0.8)
        }
    }

    private func accessibilityLabel(at index: Int) -> String {
        let position = index + 1
        let prefix = readOnly
            ? String(localized: "prefix_solution_accessibility_label \(position)")
            : String(localized: "prefix_position_accessibility_label \(position)")
        
        let state = displayStates[index]
        switch state {
        case .correct(let character):
            return String(localized: "character_box_state_correct_accessibility_label \(prefix) \(String(character))")
        case .contains(let character):
            return String(localized: "character_box_state_contains_accessibility_label \(prefix) \(String(character))")
        case .notCorrect(let character):
            return String(localized: "character_box_state_not_correct_accessibility_label \(prefix) \(String(character))")
        case .neutral:
            let character = letters[index].map { String($0) } ?? String(localized: "character_box_state_empty_accessibility_label")
            return String(localized: "character_box_state_neutral_accessibility_label \(prefix) \(character)")
        }
    }
    
}

// MARK: - KeyInputView

/// Invisible UIKeyInput to capture keyboard events.
private class KeyInputView: UIView, UIKeyInput {
    // MARK: - Properties
    
    var onInsert: ((String) -> Void)?
    var onDelete: (() -> Void)?

    override var canBecomeFirstResponder: Bool { true }
    var hasText: Bool { true }

    var keyboardType: UIKeyboardType = .asciiCapable
    var autocapitalizationType: UITextAutocapitalizationType = .allCharacters
    var autocorrectionType: UITextAutocorrectionType = .no

    // MARK: - Internal
    
    func insertText(_ text: String) {
        onInsert?(text)
    }

    func deleteBackward() {
        onDelete?()
    }
    
}

// MARK: - KeyInputRepresentable

private struct KeyInputRepresentable: UIViewRepresentable {
    // MARK: - Properties
    
    let isActive: Bool
    let onInsert: (String) -> Void
    let onDelete: () -> Void

    // MARK: - Lifecycle
    
    func makeUIView(context: Context) -> KeyInputView {
        let view = KeyInputView()
        view.onInsert = onInsert
        view.onDelete = onDelete
        view.accessibilityElementsHidden = true
        return view
    }

    func updateUIView(_ uiView: KeyInputView, context: Context) {
        uiView.onInsert = onInsert
        uiView.onDelete = onDelete

        if isActive, !uiView.isFirstResponder {
            DispatchQueue.main.async { uiView.becomeFirstResponder() }
        } else if !isActive, uiView.isFirstResponder {
            DispatchQueue.main.async { uiView.resignFirstResponder() }
        }
    }
    
}
