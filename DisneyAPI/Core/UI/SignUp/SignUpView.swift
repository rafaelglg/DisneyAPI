//
//  SignUpView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 15/1/25.
//

import SwiftUI

struct SignUpView: View {
    
    @State var email: String = ""
    @State var fullName: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack {
            Text("Sign up")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .offset(y: -30)
            
            CustomTexfield(text: $email)
            CustomTexfield(text: $fullName, prompt: "Full name")
            CustomSecureField(
                passwordText: $password,
                forgotPassword: false
            )
            
            Text("Create account")
                .callToActionButton()
                .padding()
                .toAnyButton { }
        }
    }
}

#Preview {
    NavigationStack {
        SignUpView()
    }
}
