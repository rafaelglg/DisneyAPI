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
    func toAnyButton(role: ButtonRole? = nil, option: ButtonStyleOption = .plain, action: @escaping () -> Void) -> some View {
        switch option {
        case .plain:
            plainButton(role: role, action: action)
        case .press:
            pressableButton(role: role, action: action)
        }
    }
    
    private func plainButton(role: ButtonRole? = nil, action: @escaping () -> Void) -> some View {
        Button(role: role, action: action) {
            self
        }
        .foregroundColor(role == .destructive ? .red : nil)
        .buttonStyle(.plain)
    }
    
    private func pressableButton(role: ButtonRole? = nil, action: @escaping () -> Void) -> some View {
        Button(role: role, action: action) {
            self
        }
        .foregroundColor(role == .destructive ? .red : nil)
        .buttonStyle(PressableButtonStyle())
    }
}

#Preview {
    VStack {
        Text("Show custom buttons")
            .padding()
            .frame(maxWidth: .infinity)
        
        Text("plain")
            .callToActionButton()
            .padding(.horizontal)
            .toAnyButton { }
        
        Text("pressable")
            .callToActionButton()
            .padding()
            .toAnyButton(option: .press) { }
    }
}
