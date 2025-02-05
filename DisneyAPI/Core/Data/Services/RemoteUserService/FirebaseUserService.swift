//
//  FirebaseUserService.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 31/1/25.
//

import FirebaseFirestore
import Foundation

protocol RemoteUserService: Sendable {
    func saveUser(user: UserModel) async throws
    func deleteUser(userId: String) async throws
    func getUser(userId: String) async throws -> UserModel
}

struct MockUserService: RemoteUserService {
    
    var selectMockUser: Int
    
    init(selectMockUser: Int = 0) {
        self.selectMockUser = selectMockUser
    }
    
    func saveUser(user: UserModel) async throws { }
    func getUser(userId: String) async throws -> UserModel {
        .mocks[selectMockUser]
    }
    
    func deleteUser(userId: String) async throws { }
}

struct FirebaseUserService: RemoteUserService {
    
    private var collection: CollectionReference {
        Firestore.firestore().collection("users")
    }
    
    private func userDocument(userId: String) -> DocumentReference {
        return collection.document(userId)
    }
    
    func saveUser(user: UserModel) async throws {
        try userDocument(userId: user.id).setData(from: user, merge: true)
    }
    
    func deleteUser(userId: String) async throws {
        try await userDocument(userId: userId).delete()
    }
    
    func getUser(userId: String) async throws -> UserModel {
        try await userDocument(userId: userId).getDocument(as: UserModel.self)
    }
}
