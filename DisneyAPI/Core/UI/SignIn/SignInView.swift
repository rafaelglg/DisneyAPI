//
//  SignInView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 12/1/25.
//

import SwiftUI

struct SignInView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                
                titleText
                appleButton
                googleButton
                signInButton
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Image(systemName: "x.circle.fill")
                        .toAnyButton { dismiss() }
                }
            }
        }
    }
    
    @ViewBuilder
    var titleText: some View {
        Text("Thanks for trying DisneyApi")
            .font(.title2)
            .bold()
        
        Text("Sign in or sign up to access for premium features that we provide")
            .minimumScaleFactor(0.8)
            .padding(.bottom)
    }
    
    var appleButton: some View {
        Text("Continue with Apple")
            .foregroundStyle(.white)
            .bold()
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(Color.primary, in: RoundedRectangle(cornerRadius: 15))
            .padding(.horizontal, 30)
            .toAnyButton(option: .press) { }
    }
    
    var googleButton: some View {
        Text("Continue with Google")
            .foregroundStyle(.primary)
            .bold()
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(Color.teal, in: RoundedRectangle(cornerRadius: 15))
            .padding(.horizontal, 30)
            .toAnyButton(option: .press) { }
    }
    
    var signInButton: some View {
        Text("Sign in")
            .foregroundStyle(.white)
            .bold()
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(Color.red, in: RoundedRectangle(cornerRadius: 15))
            .padding(.horizontal, 30)
            .toAnyButton(option: .press) { }
    }
}

#Preview("Regular view") {
    SignInView()
}

#Preview("Sheet view") {
    
    @Previewable @State var isSheetPresented: Bool = false
    
    ZStack {
        if isSheetPresented {
            Color.black
                .opacity(0.4) // Nivel de oscurecimiento
                .ignoresSafeArea()
                .transition(.opacity)
        }
        VStack {
            Text("Demo view")
        }
    }
    .onAppear { isSheetPresented.toggle() }
    .sheet(isPresented: $isSheetPresented) {
        SignInView()
            .presentationDetents([.fraction(0.5)])
        
    }
}
