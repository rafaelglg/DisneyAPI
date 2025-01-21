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
    }
    
    func signIn(email: String, password: String) async throws {
        try await repository.signIn(email: email, password: password)
    }
    
    func isValidEmail(email: String) -> Bool {
        repository.isValidEmail(email: email)
    }

    func isValidPassword(password: String) -> Bool {
        repository.isValidPassword(password: password)
    }
    
    func deleteAccount() async throws {
        try await repository.deleteAccount()
    }
}
