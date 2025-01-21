//
//  AuthenticationService.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 16/1/25.
//

import Foundation

protocol AuthenticationService: Sendable {
    func signIn(email: String, password: String) async throws
    func isValidEmail(email: String) -> Bool
    func isValidPassword(password: String) -> Bool
    func deleteAccount() async throws
}

struct MockAuthService: AuthenticationService {
    
    func signIn(email: String, password: String) async throws {
        
    }
    
    func isValidEmail(email: String) -> Bool {
        guard !email.isEmpty && email.count > 2 else {
            return false
        }
        return true
    }
    
    func isValidPassword(password: String) -> Bool {
        guard !password.isEmpty && password.count > 2 else {
            return false
        }
        return true
    }
    
    func deleteAccount() async throws { }
}

struct FirebaseAuthService: AuthenticationService {
    
    func signIn(email: String, password: String) async throws {
        
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidPassword(password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&#])[A-Za-z\\d@$!%*?&#]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    func deleteAccount() async throws { }
}
