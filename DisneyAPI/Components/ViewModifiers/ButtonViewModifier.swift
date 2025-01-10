//
//  ButtonViewModifier.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 10/1/25.
//

import SwiftUI

struct PressableButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.smooth, value: configuration.isPressed)
    }
}

enum ButtonStyleOption {
    case plain, press
}

extension View {
    
    @ViewBuilder
    func toAnyButton(option: ButtonStyleOption = .plain, action: @escaping () -> Void) -> some View {
        switch option {
        case .plain:
            plainButton(action: action)
        case .press:
            pressableButton(action: action)
        }
    }
    
    func plainButton(action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            self
        }
        .buttonStyle(.plain)
    }
    
    func pressableButton(action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            self
        }
        .buttonStyle(PressableButtonStyle())
    }
}
