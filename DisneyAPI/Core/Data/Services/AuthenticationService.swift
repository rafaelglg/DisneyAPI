//
//  AuthenticationService.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 16/1/25.
//

import Foundation
import FirebaseAuth

protocol AuthenticationService: Sendable {
    func getCurrentUser() -> UserAuthModel?
    func createAccount(email: String, password: String) async throws -> UserAuthModel
    func signIn(email: String, password: String) async throws -> UserAuthModel
    func signInAnonymously() async throws -> UserAuthModel
    func signOut() throws
    func deleteAccount() async throws
    func sendPasswordReset(toEmail email: String) async throws
    
    func isValidEmail(email: String) -> Bool
    func isValidPassword(password: String) -> Bool
}

struct MockAuthService: AuthenticationService {
    
    var selectMockUser: Int
    
    init(selectMockUser: Int = 0) {
        self.selectMockUser = selectMockUser
    }
    
    func getCurrentUser() -> UserAuthModel? {
        return .mocks[selectMockUser]
    }
    
    func createAccount(email: String, password: String) async throws -> UserAuthModel {
        return .mock
    }
    
    func signIn(email: String, password: String) async throws -> UserAuthModel {
        return UserAuthModel.mock
    }
    
    func signInAnonymously() async throws -> UserAuthModel {
        .mock
    }
    
    func signOut() throws { }
    
    func sendPasswordReset(toEmail email: String) async throws { }
    
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
    
    func getCurrentUser() -> UserAuthModel? {
        if let user = Auth.auth().currentUser {
            return UserAuthModel(user: user)
        }
        return nil
    }
    
    func createAccount(email: String, password: String) async throws -> UserAuthModel {
        let createdUser = try await Auth.auth().createUser(withEmail: email, password: password)
        return createdUser.toUserAuthModel
    }
    
    func signIn(email: String, password: String) async throws -> UserAuthModel {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.toUserAuthModel
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }
        
        try await user.delete()
    }
    
    func sendPasswordReset(toEmail email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func signInAnonymously() async throws -> UserAuthModel {
        return try await Auth.auth().signInAnonymously().toUserAuthModel
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
}

enum AuthError: LocalizedError {
    case userNotFound
    
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "Current authenticated user not found."
        }
    }
}

extension AuthDataResult {
    var toUserAuthModel: UserAuthModel {
        let user = UserAuthModel(user: self.user)
        return user
    }
}
