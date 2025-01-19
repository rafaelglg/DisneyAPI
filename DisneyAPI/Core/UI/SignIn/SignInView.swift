//
//  SignInView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 14/1/25.
//

import SwiftUI

struct SignInView: View {
    
    @State var signInViewModel: SignInViewModelImpl
    @FocusState private var focusState: FieldState?
    
    var body: some View {
        NavigationStack {
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
                .background(Color.black.opacity(0.001)
                    .onTapGesture {
                    hideKeyboard()
                })
                .onAppear(perform: signInViewModel.refreshCharacters)
                .onChange(of: signInViewModel.accessInteractor.allCharacters) { _, newValue in
                    signInViewModel.getCharacters(newValue)
                }
                .showCustomAlert(alert: $signInViewModel.showAlert)
            }
        }
    }
    
    private var imageLoaderRotation: some View {
        ImageLoaderViewBuilder(
            imageUrls: $signInViewModel.shuffledCharacters,
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
        .sheet(isPresented: $signInViewModel.showForgotPasswordView) {
            Text("forgotpassword")
                .presentationDetents([.medium])
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
            .toAnyButton(action: signInViewModel.onSignUpAction)
            .navigationDestination(isPresented: $signInViewModel.showSignUpView) {
                SignUpView()
            }
    }
}

#Preview("Prod") {
    let manager = DisneyManagerImpl(repository: DisneyServiceImpl())
    let container = DevPreview.shared.container
    container.register(DisneyManagerImpl.self, service: manager)

    let viewModel = SignInViewModelImpl(
        interactor: CoreInteractor(
            container: container
        )
    )
    return SignInView(signInViewModel: viewModel)
        .task(manager.getAllCharacters)
}

#Preview("Mock") {
    let manager = DisneyManagerImpl(repository: DisneyServiceMock(characters: .mock))
    let container = DevPreview.shared.container
    container.register(DisneyManagerImpl.self, service: manager)
    let viewModel = SignInViewModelImpl(
        interactor: CoreInteractor(
            container: container
        )
    )
    
    return SignInView(signInViewModel: viewModel)
        .task(manager.getAllCharacters)
}
