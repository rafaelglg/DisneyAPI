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
    func toAnyButton(option: ButtonStyleOption = .plain, progress: Bool = false, action: @escaping () -> Void) -> some View {
        switch option {
        case .plain:
            plainButton(progress: progress, action: action)
        case .press:
            pressableButton(progress: progress, action: action)
        }
    }
    
    private func plainButton(progress: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            
            ZStack {
                if progress {
                    ProgressView()
                        .tint(.white)
                        .callToActionButton()
                } else {
                    self
                }
            }
            .buttonStyle(.plain)
        }
    }
    
    private func pressableButton(progress: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            
            ZStack {
                if progress {
                    ProgressView()
                        .tint(.white)
                        .callToActionButton()
                } else {
                    self
                }
            }
        }
        .buttonStyle(PressableButtonStyle())
    }
}

#Preview {
    @Previewable @State var isLoading: Bool = false
    
    VStack {
        Text("Show custom buttons")
            .frame(maxWidth: .infinity)
        
        Text("plain")
            .callToActionButton()
            .toAnyButton { }
        
        Text("pressable")
            .callToActionButton()
            .toAnyButton(option: .press) { }
        
        Text("with loading")
            .callToActionButton(backgroundColor: .black)
            .toAnyButton(option: .plain, progress: true) { }
        
        Text("Destructive")
            .callToActionButton(backgroundColor: Color(uiColor: .quaternarySystemFill), role: .destructive)
            .toAnyButton(option: .press) { }
        
        Text("Blue color")
            .callToActionButton(backgroundColor: .blue)
            .toAnyButton(option: .press) { }
        
    }
    .padding()
}
