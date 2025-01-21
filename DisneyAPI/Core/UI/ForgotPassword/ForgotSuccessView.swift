//
//  ForgotSuccessView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 21/1/25.
//

import SwiftUI

struct ForgotSuccessView: View {
    var dismissForgotProcess: (() -> Void)?
    
    var body: some View {
        
        VStack(spacing: 10) {
            Image(systemName: "envelope")
                .foregroundStyle(.secondary)
                .bold()
                .frame(width: 70, height: 70)
                .background(.tertiary, in: Circle())
            
            Text("All done!")
                .font(.largeTitle)
                .bold()
            
            Text("An email has been successfully sent to ''email'' with instructions to reset your password.")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            Text("Ok")
                .callToActionButton(backgroundColor: .blue.opacity(0.9))
                .toAnyButton(option: .press, action: signUpSuccess)
                .padding()
            
            Text("If the email doesn't show up soon, check your spam folder.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .navigationBarBackButtonHidden()
        .padding()
    }
    
    func signUpSuccess() {
        if let dismissForgotProcess {
            dismissForgotProcess()
        }
    }
}

#Preview {
    ForgotSuccessView()
}
