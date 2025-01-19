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
    
    private let repository: AuthManagerService
    
    init(repository: AuthManagerService) {
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
}
