//
//  SignUpView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 15/1/25.
//

import SwiftUI

struct SignUpView: View {
    
    @State var viewModel: SignUpViewModelImpl
    @Environment(\.dismiss) private var dismiss
    var dismissProcessSheet: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 4) {
            
            titleSection
            fullNameSection
            emailSection
            passwordSection
            buttonSection
        }
    }
    
    var titleSection: some View {
        Text("Sign up")
            .font(.largeTitle)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .offset(y: -30)
    }
    
    var fullNameSection: some View {
        CustomTexfield(
            text: $viewModel.fullName,
            prompt: "Full name",
            textContentType: .name,
            capitalized: .words,
            keyboardType: .default
        )
            
    }
    
    var emailSection: some View {
        CustomTexfield(text: $viewModel.email, capitalized: .never)
            .textCase(.lowercase)
            .accessibilityLabel(Text(verbatim: "Registration")) // to have email suggestion in keyboard
    }
    
    var passwordSection: some View {
        CustomSecureField(passwordText: $viewModel.password, forgotPassword: false
        )
    }
    
    var buttonSection: some View {
        Text("Create account")
            .callToActionButton()
            .toAnyButton(progress: viewModel.isloading, action: signUpSuccess)
            .padding()
    }
    
    func signUpSuccess() {
        viewModel.onChangeLoading(true)
        Task {
            if let dismissProcessSheet {
                try? await Task.sleep(for: .seconds(4))
                dismissProcessSheet()
                viewModel.onChangeLoading(false)
            }
        }
    }
}

#Preview {
    
    let container = DevPreview.shared.container
    
    SignUpView(viewModel: SignUpViewModelImpl(interactor: CoreInteractor(container: container)))
}
