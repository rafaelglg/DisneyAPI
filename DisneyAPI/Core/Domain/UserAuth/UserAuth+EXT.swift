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
    init(user: User, password: String = "") {
        self.id = user.uid
        self.fullName = user.displayName ?? ""
        self.isAnonymous = user.isAnonymous
        self.email = user.email ?? ""
        self.dateCreated = user.metadata.creationDate
        self.lastSignInDate = user.metadata.lastSignInDate
        self.profilePicture = user.photoURL?.absoluteString
        self.password = password
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
    func toUserAuthModel(withPassword password: String = "") -> UserAuthModel {
        let user = UserAuthModel(user: self.user, password: password)
        return user
    }
    
    func toUserAuthModel(withUser user: UserAuthModel) -> UserAuthModel {
        let user = UserAuthModel(id: user.id, fullName: user.fullName, email: user.email, password: user.password, dateCreated: user.dateCreated, profilePicture: user.profilePicture, isAnonymous: user.isAnonymous, lastSignInDate: user.lastSignInDate)
        return user
    }
    
    func toUserAuthModel(with googleProfile: GIDProfileData?) -> UserAuthModel {
        return UserAuthModel(
            user: self.user,
            googleProfile: googleProfile
        )
    }
}

extension GIDProfileData {
    func toUserAuthModel(with user: User) -> UserAuthModel {
        return UserAuthModel(user: user, googleProfile: self)
    }
}

extension UserAuthModel {
    
    func toUserModel(fullname: String = "") -> UserModel {
        return UserModel(
            id: self.id,
            fullName: self.fullName ?? fullname,
            email: self.email,
            dateCreated: self.dateCreated,
            profilePicture: self.profilePicture,
            isAnonymous: self.isAnonymous,
            lastSignInDate: self.lastSignInDate
        )
    }
}
