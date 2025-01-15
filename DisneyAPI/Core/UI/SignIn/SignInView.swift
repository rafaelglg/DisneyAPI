//
//  SignInView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 14/1/25.
//

import SwiftUI

struct SignInView: View {
    
    @Environment(CharacterManagerImpl.self) var characterManager
    @State var signInViewModel: SignInViewModelImpl
    @FocusState private var focusState: FieldState?
    
    var body: some View {
        ZStack {
            ScrollView {
                
                VStack(alignment: .center) {
                    
                    imageLoaderRotation
                    signInText
                    textfieldEmail
                    secureFieldPassword
                    buttonSection
                    registerSection
                }
                // Tap background to hide keyboard
                .background(Color.black.opacity(0.001).onTapGesture {
                    hideKeyboard()
                })
                .sheet(isPresented: $signInViewModel.showForgotPasswordView) {
                    Text("forgotpassword")
                        
                        .presentationDetents([.medium])
                }
                .showCustomAlert(alert: $signInViewModel.showAlert)
            }
        }
    }
    
    @ViewBuilder
    private var imageLoaderRotation: some View {
        let array = characterManager.allCharacters.first(10)
            .map { $0.imageUrl ?? "" }
            .shuffled()
        
        ImageLoaderViewBuilder(
            imageUrls: array,
            animationDuration: 5.0,
            animationType: .blurReplace(.upUp))
        .frame(maxWidth: .infinity)
        .frame(height: 400)
        .clipShape(.rect(cornerRadius: 0))
        .padding(.bottom)
    }
    
    private var signInText: some View {
        Text("Sign in")
            .font(.largeTitle)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }
    
    private var textfieldEmail: some View {
        CustomTexfield(text: $signInViewModel.emailText)
            .focused($focusState, equals: .email)
            .onChange(of: signInViewModel.emailText) { _, _ in
                signInViewModel.updateSignInValidation()
            }
            .onSubmit {
                focusState = .password
            }
    }
    
    private var secureFieldPassword: some View {
        CustomSecureField(
            passwordText: $signInViewModel.passwordText,
            forgetPasswordAction: signInViewModel.onForgotPasswordAction
        )
        .onChange(of: signInViewModel.passwordText) {
            signInViewModel.updateSignInValidation()
        }
        .focused($focusState, equals: .password)
        .padding(.bottom)
    }
    
    private var buttonSection: some View {
        Text("Continue")
            .callToActionButton(backgroundColor: signInViewModel.signInValidated ? .red : .gray)
            .padding(.horizontal)
            .toAnyButton {
                do {
                    try signInViewModel.performSignIn()
                } catch {
                    signInViewModel.showAlert = AnyAppAlert(error: error)
                }
            }
            .disabled(signInViewModel.signInValidated == false)
    }
    
    private var registerSection: some View {
        Text("Create account")
            .font(.headline)
            .foregroundStyle(.link)
            .padding()
            .toAnyButton { }
    }
}

#Preview("Prod") {
    
    @Previewable @State var manager = CharacterManagerImpl(
        repository: CharacterServiceImpl()
    )
    
    let viewModel = SignInViewModelImpl(
        interactor: CoreInteractor(
            characterManager: manager
        )
    )
    
    NavigationStack {
        
        if manager.isLoading {
            SignInView(signInViewModel: viewModel)
                .redacted(reason: .placeholder)
                .environment(manager)
        } else {
            SignInView(signInViewModel: viewModel)
                .environment(manager)
        }
    }
}

#Preview("Mock") {
    
    @Previewable @State var manager = CharacterManagerImpl(
        repository: CharacterServiceMock(characters: .mock, delay: 0.1)
    )
    
    let viewModel = SignInViewModelImpl(
        interactor: CoreInteractor(
            characterManager: manager
        )
    )
    
    return NavigationStack {
        
        if manager.isLoading {
            SignInView(signInViewModel: viewModel)
                .redacted(reason: .placeholder)
                .environment(manager)
        } else {
            SignInView(signInViewModel: viewModel)
                .environment(manager)
        }
    }
}
