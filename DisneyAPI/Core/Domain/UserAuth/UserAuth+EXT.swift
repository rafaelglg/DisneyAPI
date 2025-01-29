//
//  UserAuth+EXT.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 22/1/25.
//
import FirebaseAuth
import GoogleSignIn

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
    
    init(user: User, googleProfile: GIDProfileData?) {
        self.id = user.uid
        self.fullName = googleProfile?.name ?? ""
        self.isAnonymous = user.isAnonymous
        self.email = googleProfile?.email ?? ""
        self.dateCreated = .now
        self.lastSignInDate = user.metadata.lastSignInDate
        self.profilePicture = googleProfile?.imageURL(withDimension: 200)?.absoluteString ?? ""
        self.password = nil
    }
}

extension AuthDataResult {
    var toUserAuthModel: UserAuthModel {
        let user = UserAuthModel(user: self.user)
        return user
    }
    
    func toUserAuthModel(with googleProfile: GIDProfileData?) -> UserAuthModel {
        return UserAuthModel(
            user: self.user,
            googleProfile: googleProfile
        )
    }
}
