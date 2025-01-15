//
//  SignInViewModel.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 15/1/25.
//

import Foundation

@MainActor
protocol SignViewModelInteractor {
    func signIn(email: String, password: String) async throws
}

extension CoreInteractor: SignViewModelInteractor { }

@MainActor
@Observable
final class SignInViewModelImpl {
    
    let interactor: SignViewModelInteractor
    
    var emailText: String = ""
    var passwordText: String = ""
    var showAlert: AnyAppAlert?
    
    var signInValidated: Bool = false
    var showForgotPasswordView: Bool = false
    
    init(interactor: SignViewModelInteractor) {
        self.interactor = interactor
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
                try await interactor.signIn(email: "", password: "")
            } catch {
                throw error
            }
        }
    }
    
    func onForgotPasswordAction() {
        showForgotPasswordView.toggle()
    }
}
