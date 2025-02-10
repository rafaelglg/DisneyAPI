//
//  FirebaseUserService.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 31/1/25.
//

@preconcurrency import FirebaseFirestore
import Foundation

protocol RemoteUserService: Sendable {
    func saveUser(user: UserModel) async throws
    func deleteUser(userId: String) async throws
    func getUser(userId: String) async throws -> UserModel
    func addUserListener(userId: String) -> AsyncThrowingStream<UserModel, Error>
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
    
    func addUserListener(userId: String) -> AsyncThrowingStream<UserModel, Error> {
        AsyncThrowingStream { continuation in
            continuation.yield(.mocks[selectMockUser])
        }
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
    
    func addUserListener(userId: String) -> AsyncThrowingStream<UserModel, Error> {
        AsyncThrowingStream(UserModel.self) { continuation in
            let listener = userDocument(userId: userId).addSnapshotListener { documentSnapshot, error in
                
                guard error == nil else {
                    continuation.finish(throwing: error)
                    return
                }
                
                guard let documentSnapshot else {
                    continuation.finish(throwing: DocumentError.noDocumentFound)
                    return
                }
                
                do {
                    let item = try documentSnapshot.data(as: UserModel.self)
                    continuation.yield(item)
                } catch {
                    print(error)
                    continuation.finish(throwing: error)
                }
            }
            
            continuation.onTermination = { @Sendable _ in
                listener.remove()
            }
        }
    }
    
    func deleteUser(userId: String) async throws {
        try await userDocument(userId: userId).delete()
    }
    
    func getUser(userId: String) async throws -> UserModel {
        try await userDocument(userId: userId).getDocument(as: UserModel.self)
    }
}

enum DocumentError: Error {
    case noDocumentFound
}
