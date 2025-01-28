//
//  AuthManagerImpl.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 15/1/25.
//

import Foundation

@MainActor
@Observable
final class AuthManagerImpl {
    
    private let repository: AuthenticationService
    private(set) var user: UserAuthModel?
    
    init(repository: AuthenticationService) {
        self.repository = repository
        self.user = repository.getCurrentUser()
    }
    
    func signIn(email: String, password: String) async throws {
        let result = try await repository.signIn(email: email, password: password)
        self.user = result
    }
    
    func signUp(email: String, password: String) async throws {
        user = try await repository.createAccount(email: email, password: password)
    }
    
    func signInAnonymously() async throws -> UserAuthModel {
        let result = try await repository.signInAnonymously()
        self.user = result
        return result
    }
    
    func sendPasswordReset(email: String) async throws {
        try await repository.sendPasswordReset(toEmail: email)
    }
    
    func getCurrentUser() throws -> UserAuthModel? {
        return repository.getCurrentUser()
    }
    
    func signOut() throws {
        try repository.signOut()
        user = nil
    }
    
    func deleteAccount() async throws {
        try await repository.deleteAccount()
        user = nil
    }
    
    func isValidEmail(email: String) -> Bool {
        repository.isValidEmail(email: email)
    }
    
    func isValidPassword(password: String) -> Bool {
        repository.isValidPassword(password: password)
    }
}
