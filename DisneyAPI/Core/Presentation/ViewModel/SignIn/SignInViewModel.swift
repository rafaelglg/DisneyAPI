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
}

extension CoreInteractor: SignViewModelInteractor { }

@MainActor
@Observable
final class SignInViewModelImpl {
    
    private let interactor: SignViewModelInteractor
    
    var emailText: String = ""
    var passwordText: String = ""
    var showAlert: AnyAppAlert?
    var showForgotPasswordView: Bool = false
    var showSignUpView: Bool = false
    var shuffledCharacters: [String] = []
    
    private(set) var allCharacters: [CharacterDataResponse] = []
    private(set) var signInValidated: Bool = false
    
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
    
    // Método para validar ambos campos
    func updateSignInValidation() {
        signInValidated = isValidEmail() && isValidPassword()
    }
    
    private func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: emailText)
    }

    private func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&#])[A-Za-z\\d@$!%*?&#]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: passwordText)
    }
    
    func performSignIn() throws {
        
        guard signInValidated else {
            throw URLError(.badURL)
        }
        
        Task {
            do {
                try await interactor.signIn(email: emailText, password: passwordText)
            } catch {
                throw error
            }
        }
    }
    
    func onForgotPasswordAction() {
        showForgotPasswordView.toggle()
    }
    
    func onSignUpAction() {
        showSignUpView.toggle()
    }
    
}
