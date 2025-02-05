//
//  GoogleService.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 28/1/25.
//
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth

@MainActor
struct SignInWithGoogleHelper {

    func signIn() async throws -> GIDGoogleUser? {
        guard let topVC = Utilities.getTopViewController() else {
            throw GoogleAuthError.notFoundTopViewController
        }
        
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        return result.user
    }
}

enum GoogleAuthError: LocalizedError {
    case notFoundTopViewController
    case notFoundIDToken
    
    var errorDescription: String? {
        switch self {
            
        case .notFoundTopViewController:
            return "The top current viewController could not be found"
        case .notFoundIDToken:
            return "The idToken from google service signIn could not be found"
        }
    }
}

// Needs to conform to @unchecked @retroactive Sendable because GIDSignInResult the result from signIn from google does not conform to sendable. And the helper needs to be on the MainThread to show the UI in screen
extension GIDSignInResult: @unchecked @retroactive Sendable { }
extension GIDGoogleUser: @unchecked @retroactive Sendable { }

extension GIDGoogleUser {
    var toUserAuthModel: UserAuthModel? {
        UserAuthModel(
            id: self.userID ?? "",
            fullName: self.profile?.name ?? "",
            email: self.profile?.email ?? "",
            password: nil,
            dateCreated: .now,
            profilePicture: nil,
            isAnonymous: false,
            lastSignInDate: nil
        )
    }
}
