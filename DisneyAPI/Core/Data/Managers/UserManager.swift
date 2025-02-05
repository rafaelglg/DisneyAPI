//
//  UserManager.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 1/2/25.
//
import Foundation

@MainActor
@Observable
final class UserManagerImpl {
    private let repository: RemoteUserService
    private(set) var currentUser: UserModel?
    
    init(repository: RemoteUserService) {
        self.repository = repository
        self.currentUser = currentUser
    }
    
    func getCurrentUser(userId: String) async -> UserModel? {
        do {
            let user = try await repository.getUser(userId: userId)
            currentUser = user
            return user
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func saveUser(user: UserModel) async throws {
        try await repository.saveUser(user: user)
    }
    
    func signOut() {
        currentUser = nil
    }
    
    func deleteUser(userId: String) async throws {
        try await repository.deleteUser(userId: userId)
        signOut()
    }
}

enum UserManagerError: LocalizedError {
    case noUserId
    case noUser
    
    var errorDescription: String? {
        switch self {
        case .noUserId:
            return "No user id was found."
        case .noUser:
            return "No user was found"
        }
    }
}
