//
//  UserAuth+EXT.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 22/1/25.
//
import FirebaseAuth

extension UserAuthModel {
    /// Transform User from firebase to local user
    init(user: User) {
        self.id = user.uid
        self.fullName = user.displayName ?? ""
        self.isAnonymous = user.isAnonymous
        self.email = user.email ?? ""
        self.dateCreated = user.metadata.creationDate
        self.lastSignInDate = user.metadata.lastSignInDate
        self.profilePicture = user.photoURL?.absoluteString
        self.password = nil
    }
}
