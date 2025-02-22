//
//  CustomSecureField.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 15/1/25.
//
import SwiftUI

struct CustomSecureField: View {
    
    @Binding var passwordText: String
    var prompt: String = "Password"
    var forgotPassword: Bool = true
    
    @State private var seePassword: Bool = false
    var forgetPasswordAction: (() -> Void)?
    
    var body: some View {
        ZStack(alignment: .trailing) {
            if !seePassword {
                passwordTextfield
            } else {
                seenPasswordTextfield
            }
            
            HStack(spacing: 20) {
                eyesButton
                if forgotPassword {
                    forgotButton
                }
            }
            .padding(.trailing, 40)
        }
    }
    
    var passwordTextfield: some View {
        SecureField(text: $passwordText) {
            Text(prompt)
                .bold()
            
        }
        .textContentType(.password)
        
        .submitLabel(.done)
        .frame(height: 54)
        .padding(.horizontal) // Move the prompt more to the left
        .padding(.trailing, forgotPassword ? 120 : 50) // To clipped the text before the buttons
        .background(.textfieldBackground, in: RoundedRectangle(cornerRadius: 15))
        .frame(maxWidth: .infinity)
        .padding() // Sepate secureField from the safe area
    }
    
    var seenPasswordTextfield: some View {
        TextField(text: $passwordText) {
            Text(prompt)
                .bold()
        }
        .textContentType(.password)
        .submitLabel(.done)
        .frame(height: 54)
        .padding(.leading) // Move the prompt more to the left
        .padding(.trailing, forgotPassword ? 120 : 50) // To clipped the text before the buttons
        .background(.textfieldBackground, in: RoundedRectangle(cornerRadius: 15))
        .frame(maxWidth: .infinity)
        .padding() // Separate textfield from the safe area
    }
    
    var eyesButton: some View {
        Button {
            seePassword.toggle()
        } label: {
            Image(systemName: seePassword ? "eye.fill" : "eye.slash.fill")
                .tint(.secondary)
                .bold()
        }
    }
    
    var forgotButton: some View {
        Button {
            if let forgetPasswordAction {
                forgetPasswordAction()
            }
        } label: {
            Text("Forgot?")
                .font(.subheadline)
                .bold()
        }
    }
}

#Preview("With forgot password") {
    @Previewable @State var passwordText: String = ""
    @Previewable @State var forgotPasswordAction: Bool = false
    @Previewable @State var passwordText2: String = ""
    
    NavigationStack {
        CustomSecureField(passwordText: $passwordText) {
            forgotPasswordAction.toggle()
        }
        
        .sheet(isPresented: $forgotPasswordAction) {
            Text("forgot password view")
                .presentationDetents([.medium])
        }
        
        CustomSecureField(
            passwordText: $passwordText2,
            forgotPassword: false)
    }
}
