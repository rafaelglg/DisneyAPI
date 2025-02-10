//
//  GoogleSignInButtonView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 28/1/25.
//
import SwiftUI

struct GoogleSignInButtonView: View {
    
    var isLoading: Bool = false
    @MainActor let action: () -> Void
    var body: some View {
        VStack {
            HStack {
                
                Button(action: action) {
                    HStack {
                        if isLoading {
                            ProgressView()
                        } else {
                            Image(.googleIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                            Text("Sign in with Google")
                                .foregroundStyle(.black)
                        }
                    }
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.textfieldBackground, in: RoundedRectangle(cornerRadius: 15))
                }
                .buttonStyle(PressableButtonStyle())
            }
        }
    }
}

#Preview("Button normal") {
    GoogleSignInButtonView {}
    .padding()
}

#Preview("Button is loading") {
    GoogleSignInButtonView(isLoading: true) {}
    .padding()
}
