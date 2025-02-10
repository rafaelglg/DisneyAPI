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
    private var taskListener: Task<Void, Error>?
    
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
        addUserListener(userId: user.id)
    }
    
    func addUserListener(userId: String) {
        taskListener?.cancel()
        taskListener = Task {
            do {
                for try await value in repository.addUserListener(userId: userId) {
                    print("user listener success: \(String(describing: value.id))")
                    print("user: \(String(describing: value))")
                    self.currentUser = value
                }
            } catch {
                print("error en el addUserListener: \(error), \(#file)")
            }
        }
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
