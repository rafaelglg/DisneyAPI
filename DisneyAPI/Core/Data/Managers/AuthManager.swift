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
    private var taskListener: Task<Void, Error>?
    
    init(repository: AuthenticationService) {
        self.repository = repository
        self.user = repository.getUserAuth()
        addAuthListener()
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
    
    /// Adds a listener for any changes in Firebase authentication. Keeps the user information updated throughout the app.
    private func addAuthListener() {
        taskListener?.cancel()
        taskListener = Task {
            for await value in repository.addUserAthenticatedListener() {
                self.user = value
                print("auth listener success: \(String(describing: value?.id))")
                print("user from authentication: \(String(describing: self.user))")
            }
        }
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
