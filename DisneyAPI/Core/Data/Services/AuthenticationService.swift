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
    func signInWithGoogle() async throws -> UserAuthModel
    func reAuthenticateUser() async throws -> UserAuthModel?
    
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
    
    func signInWithGoogle() async throws -> UserAuthModel {
        .mock
    }
    
    func createAccount(email: String, password: String) async throws -> UserAuthModel {
        return .mock
    }
    
    func reAuthenticateUser() async throws -> UserAuthModel? {
        .mock
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
    
    // MARK: - SSO with password
    func signIn(email: String, password: String) async throws -> UserAuthModel {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.toUserAuthModel(with: password)
    }
    
    func sendPasswordReset(toEmail email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func createAccount(email: String, password: String) async throws -> UserAuthModel {
        let createdUser = try await Auth.auth().createUser(withEmail: email, password: password)
        return createdUser.toUserAuthModel(with: password)
    }
    
    // MARK: - SSO with google
    func getGoogleCredentials(idToken: String, accessToken: String) -> AuthCredential {
        return GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
    }
    
    /// Obtain tokens needed from google signIn result GIDGoogleUser
    func getGoogleTokens(idToken: String?, accessToken: String) async throws -> (idToken: String, accessToken: String) {
        
        guard let idToken else {
            throw GoogleAuthError.notFoundIDToken
        }
        
        return (idToken, accessToken)
    }
    
    func signInWithGoogle() async throws -> UserAuthModel {

        guard let gidSignInResult = try await SignInWithGoogleHelper().signIn() else {
            throw AuthError.credentialNotFound
        }
        
        let tokens = try await getGoogleTokens(idToken: gidSignInResult.idToken?.tokenString, accessToken: gidSignInResult.accessToken.tokenString)
        let credentials = getGoogleCredentials(idToken: tokens.idToken, accessToken: tokens.accessToken)
        
        if let user = Auth.auth().currentUser, user.isAnonymous {
            // Try when user is anonymous
            do {
                // Link anonymous user to google service SSO
                let result = try await user.link(with: credentials)
                return result.toUserAuthModel(with: gidSignInResult.profile)
            } catch let error as NSError {
                
                // When user has an account try to SignIn to same account, we use cases .providerAlreadyLinked or .credentialAlreadyInUse errors when is already linked.
                let authError = AuthErrorCode(rawValue: error.code)
                switch authError {
                case .providerAlreadyLinked, .credentialAlreadyInUse:
                    if let secondaryCredentials = error.userInfo["FIRAuthErrorUserInfoUpdatedCredentialKey"] as? AuthCredential {
                        let result = try await Auth.auth().signIn(with: secondaryCredentials)
                        return result.toUserAuthModel(with: gidSignInResult.profile)
                    }
                default:
                    break
                }
            }
        }
        
        // Otherwise sign in to new account
        let result = try await Auth.auth().signIn(with: credentials)
        return result.toUserAuthModel(with: gidSignInResult.profile)
    }
    
    // MARK: Shared methods
    func getCurrentUser() -> UserAuthModel? {
        if let user = Auth.auth().currentUser {
            return UserAuthModel(user: user)
        }
        return nil
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
    
    /// Recover credentials from provider
    /// - Parameters:
    ///   - provider: Enum case to have the providers (password, google.com...)
    /// - Returns: returns tuple of crendentials and google user with info
    func getCredentials(for provider: ProviderID?, userAuth: User) async throws -> (crendentials: AuthCredential?, userModel: UserAuthModel?) {
        switch provider {
        case .password:
            break
        case .google:
            guard let signInResult = try await SignInWithGoogleHelper().signIn() else {
                throw AuthError.credentialNotFound
            }
            
            let token = try await getGoogleTokens(
                idToken: signInResult.idToken?.tokenString,
                accessToken: signInResult.accessToken.tokenString
            )
            
            return (getGoogleCredentials(idToken: token.idToken, accessToken: token.accessToken), signInResult.profile?.toUserAuthModel(with: userAuth))
        case .apple:
            break
        case .facebook:
            break
        case .unknown:
            break
        case .none:
            break
        }
        
        return (nil, nil)
    }
    
    func reAuthenticateUser() async throws -> UserAuthModel? {
        guard let authUser = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }
        
        var providerID: ProviderID?
        var credentials: AuthCredential?
        var userProfile: UserAuthModel?

        // Loop in which provider is using then get credetials
        for provider in authUser.providerData {
            providerID = ProviderID(from: provider.providerID)
            let result = try await getCredentials(for: providerID, userAuth: authUser)
            credentials = result.crendentials
            userProfile = result.userModel
        }
        
        guard let validCredentials = credentials else {
            if providerID == .password {
                return nil
            }
            throw AuthError.credentialNotFound
        }
        
        guard let userProfile else {
            throw AuthError.userNotFound
        }
        
        return try await authUser.reauthenticate(with: validCredentials).toUserAuthModel(withUser: userProfile)
    }
    
    func signInAnonymously() async throws -> UserAuthModel {
        return try await Auth.auth().signInAnonymously().toUserAuthModel()
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

enum ProviderID: String {
    case password = "password"
    case google = "google.com"
    case apple = "apple.com"
    case facebook = "facebook.com"
    case unknown
    
    init(from rawValue: String) {
        self = ProviderID(rawValue: rawValue) ?? .unknown
    }
}

enum AuthError: LocalizedError {
    case userNotFound
    case credentialNotFound
    case requiresRecentLogin
    
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "Current authenticated user not found."
        case .credentialNotFound:
            return "The credentials could not be found"
        case .requiresRecentLogin:
            return "This operation is sensitive and in order to do it you need to sign in again first."
        }
    }
}
