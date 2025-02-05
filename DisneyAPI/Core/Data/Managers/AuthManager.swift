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
        self.user = repository.getUserAuth()
    }
    
    func signIn(email: String, password: String) async throws -> UserAuthModel {
        let result = try await repository.signIn(email: email, password: password)
        self.user = result
        return result
    }
    
    func signUp(email: String, password: String) async throws -> UserAuthModel {
        let user = try await repository.createAccount(email: email, password: password)
        self.user = user
        return user
    }
    
    func signInWithGoogle() async throws -> UserAuthModel {
        let result = try await repository.signInWithGoogle()
        user = result
        return result
    }
    
    func reAuthenticateUser() async throws {
        user = try await repository.reAuthenticateUser()
    }
    
    func signInAnonymously() async throws -> UserAuthModel {
        let result = try await repository.signInAnonymously()
        self.user = result
        return result
    }
    
    func sendPasswordReset(email: String) async throws {
        try await repository.sendPasswordReset(toEmail: email)
    }
    
    func getUserAuth() -> UserAuthModel? {
        return repository.getUserAuth()
    }
    
    func signOut() throws {
        try repository.signOut()
        setUserToNil()
    }
    
    func deleteAccount() async throws {
        try await repository.deleteAccount()
    }
    
    func isValidEmail(email: String) -> Bool {
        repository.isValidEmail(email: email)
    }
    
    func isValidPassword(password: String) -> Bool {
        repository.isValidPassword(password: password)
    }
    
    func setUserToNil() {
        user = nil
    }
}
