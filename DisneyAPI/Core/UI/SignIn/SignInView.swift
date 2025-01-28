//
//  SignInView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 14/1/25.
//

import SwiftUI

enum SignInNavigation: Hashable {
    case signUp
    case forgotPassword
}

struct SignInView: View {
    
    @Environment(DependencyContainer.self) var container
    @State var signInViewModel: SignInViewModelImpl
    @FocusState private var focusState: FieldState?
    var dismissProcessSheet: (() -> Void)?
    @State var showforgotPasswordView: Bool = false
    
    var body: some View {
        NavigationStack(path: $signInViewModel.path) {
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
                .onAppear {
                    signInViewModel.onChangeDismissProccessSheet(dismissProcessSheet)
                    signInViewModel.refreshCharacters()
                }
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
            ForgotPasswordView(
                viewModel: ForgotPasswordViewModelImpl(
                    interactor: CoreInteractor(
                        container: container
                    )
                ),
                dismissForgotProcess: {
                signInViewModel.showForgotPasswordView = false
            })
                .presentationDetents([.fraction(0.50)])
        }
        .focused($focusState, equals: .password)
        .padding(.bottom)
    }
    
    private var buttonSection: some View {
        Text("Continue")
            .callToActionButton(backgroundColor: signInViewModel.signInValidated ? .red : .gray)
            .toAnyButton(option: .press, progress: signInViewModel.isLoading, action: signInViewModel.onPerformSignIn)
            .disabled(signInViewModel.signInValidated == false)
            .padding(.horizontal)
    }
    
    private var registerSection: some View {
        Text("Create account")
            .font(.headline)
            .foregroundStyle(.link)
            .padding()
            .toAnyButton(action: signInViewModel.onSignUpAction)
            .navigationDestination(for: SignInNavigation.self) { _ in
                SignUpView(
                    viewModel: SignUpViewModelImpl(
                        interactor: CoreInteractor(
                            container: container
                        )
                    ), dismissProcessSheet: dismissProcessSheet
                )
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
        .previewEnvironment()
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
        .previewEnvironment()
}
