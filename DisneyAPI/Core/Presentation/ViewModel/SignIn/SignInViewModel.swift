//
//  SignInViewModel.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 15/1/25.
//

import Foundation

@MainActor
protocol SignViewModelInteractor {
    var allCharacters: [CharacterDataResponse] { get }
    
    func signIn(email: String, password: String) async throws
    func isValidEmail(email: String) -> Bool
    func isValidPassword(password: String) -> Bool
}

extension CoreInteractor: SignViewModelInteractor { }

@MainActor
@Observable
final class SignInViewModelImpl {
    
    private let interactor: SignViewModelInteractor
    
    private(set) var allCharacters: [CharacterDataResponse] = []
    private(set) var signInValidated: Bool = false
    private(set) var isLoading: Bool = false
    private(set) var dismissProcessSheet: (() -> Void)?
    
    var emailText: String = ""
    var passwordText: String = ""
    var showAlert: AnyAppAlert?
    var showForgotPasswordView: Bool = false
    var showSignUpView: Bool = false
    var shuffledCharacters: [String] = []
    var path: [SignInNavigation] = []
    
    init(interactor: SignViewModelInteractor) {
        self.interactor = interactor
    }
    
    var accessInteractor: SignViewModelInteractor {
        interactor
    }
    
    func refreshCharacters() {
        guard allCharacters.isEmpty else { return }
        
        let characters = interactor.allCharacters
        getCharacters(characters)
    }
    
    func getCharacters(_ newValue: [CharacterDataResponse]) {
        allCharacters = newValue
        shuffleCharacters()
    }
    
    private func shuffleCharacters() {
        shuffledCharacters = allCharacters
            .shuffled()
            .first(10)
            .map { $0.imageUrl ?? "" }
    }
    
    // Method to valided both: email and password
    func updateSignInValidation() {
        
        let isEmailValid = interactor.isValidEmail(email: emailText)
        let isPasswordValid = interactor.isValidPassword(password: passwordText)
        
        signInValidated = isEmailValid && isPasswordValid
    }
    
    func onPerformSignIn() {
        
        guard signInValidated else {
            showAlert = AnyAppAlert(title: "Email or password not correct. Please type again.")
            return
        }
        
        isLoading = true
        
        Task {
            
            defer { isLoading = false }
            
            do {
                try await interactor.signIn(email: emailText, password: passwordText)
                dismissProcessSheet?()
            } catch let error as NSError {
                let errorMessage = CustomErrorMessage(errorDescription: error.getErrorMessage())
                showAlert = AnyAppAlert(error: errorMessage)
            }
        }
    }
    
    func onChangeDismissProccessSheet(_ newValue: (() -> Void)?) {
        dismissProcessSheet = newValue
    }
    
    func onForgotPasswordAction() {
        showForgotPasswordView.toggle()
    }
    
    func onSignUpAction() {
        path.append(.signUp)
    }
    
}
